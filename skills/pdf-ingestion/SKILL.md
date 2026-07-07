---
name: pdf-ingestion
description: Get a PDF into the model without blowing the context window or losing structure. Native PDF beats OCR-then-text for most cases; extract-then-summarize beats native for very long docs.
when_to_use: user drops a PDF, "read this report", extracting tables/figures from a doc, long-form doc summarization, spec document that lives as PDF
---

# PDF Ingestion

Three ways to feed a PDF to the model, in increasing order of preprocessing:

1. **Native PDF input** — pass the file directly. Model sees pages as images + extracted text. Best for docs under ~100 pages with meaningful layout (tables, figures, forms). Preserves structure.

2. **Text extraction then send** — `pdftotext` / `pypdf` / equivalent, then send the text. Loses layout but cheap. Fine for prose-heavy docs where tables don't matter.

3. **Extract → chunk → summarize → send** — for docs >100 pages or when you'll query the same doc many times. Preprocess once, cache the summary.

## Deciding which path

| Doc shape | Path |
|---|---|
| <20 pages, layout matters (report, form, invoice) | Native |
| <20 pages, pure prose (article, memo) | Text extraction |
| 20-100 pages, mixed | Native, but chunk if context tight |
| >100 pages | Extract → chunk → summarize |
| Scanned PDF (no text layer) | OCR first (Tesseract or vision model), then treat as extracted text |
| Tables are the point | Native — text extractors mangle tables |
| Figures/diagrams are the point | Native + explicit "describe the figure on page N" prompt |

## Native PDF — the good defaults

- Cache the PDF at a prompt-caching breakpoint (see `prompt-caching`). Native PDFs are large — every uncached turn costs full input price on the whole doc.
- Ask about **specific pages** ("summarize section 3.2 on page 14") rather than the whole doc. The model handles targeted queries better than "summarize this 80-page report".
- Follow up with **page-cited claims** — "on which page does the doc say X?" — as a sanity check the model isn't hallucinating.

## Extract-then-send — the traps

- **`pdftotext` reading order.** Multi-column PDFs come out as interleaved lines. Use `pdftotext -layout` for column preservation, or `pdftotext -raw` for straight reading order — pick per doc, don't guess.
- **Tables become word soup.** If tables are load-bearing, native or per-table image extraction. Not text.
- **Headers/footers repeat on every page.** Strip them before sending, or the model will treat them as content.
- **Footnotes drift** to random positions in the extracted stream. Filter or accept the noise.

## Extract → chunk → summarize (long docs)

- Chunk by section, not by token count. A section-aware split respects the doc's logic; a naive 4K-token split cuts sentences and tables.
- Summarize per section into a "map" — 1-2 paragraphs each. Keep the map short enough to fit in context whole (~2-4K tokens for a 200-page doc).
- Store the full section text alongside the map (paths in a manifest). Fetch on demand when a question needs detail beyond the summary.
- Cache the map at a prompt-caching breakpoint so multi-turn Q&A over the doc doesn't reprocess.

## Red flags

- **Sending a 200-page PDF native to answer one question.** Extract the relevant page range first.
- **Trusting the text extractor on a form or invoice.** Layout carries meaning. Use native.
- **OCR'ing a PDF that already has a text layer.** Check `pdftotext -q file.pdf -` first — if text comes out, no OCR needed.
- **No page citations in output.** Model can hallucinate confidently across long PDFs. Force page numbers into the response format.
- **Re-uploading the same PDF every turn without caching.** Cost climbs linearly; a 5-minute cache fixes it.

## Loopkit-adjacent

If the PDF is a spec, extract it into `PROMPT.md` via `spec-first` — the agent should re-read prose, not re-scan the PDF, on every turn.
