# Question Sync Prompt

Cross-check every question in `All_questions.txt` against the full Excel workbook `DevOps_Interview_Questions.xlsx` (all sheets; it is the only .xlsx in this folder), and update the workbook per these rules.

> **Source tag:** this template uses `LinkedIn` as the default tag prefix (since that's where the original author's questions mostly came from), producing tags like `LinkedIn-1`, `LinkedIn-2`. If your own question source is different (Glassdoor, Naukri, a WhatsApp group, mock interviews, etc.), replace `LinkedIn` everywhere below with your own short source name — the mechanism is identical either way, only the label changes.

## Matching

- Treat a txt question as "already available" only if an existing row is an exact or clearly-equivalent match (same meaning, different wording is fine — e.g. two differently-worded questions asking the same underlying thing about the same concept still count as a match). If a match is only loosely/tangentially related (e.g. covers a neighboring concept but not the actual question), treat it as **not available** and flag it for me to confirm before adding, rather than auto-deciding either way.
- When deciding whether a question "recurs" across sources (for incrementing the tag counter) or whether two rows are duplicates, shared phrasing or a shared sentence template is NOT enough on its own — e.g. the same question template applied to two different specific subjects (two different tools, two different keywords, two different scenarios) is two different questions, not two occurrences of the same one. Require near-identical wording or confirmed semantic equivalence (same underlying ask, same answer would work for both) before treating two rows as the same question.
- The workbook's sheet list and structure can change between runs (new sheets get added directly in Excel between sessions). Always fetch a fresh sheet list and column headers at the start of each run rather than assuming a prior session's layout still holds.

## Adding new questions

- Add each txt question not already available as a new row in the most topically appropriate existing sheet (don't create new sheets). Match the column structure and blank-field conventions already used by other recently-added stub rows in that sheet (e.g. leave Sr.No/level/years/answer blank unless I ask you to fill them in).
- Set that row's Priority Count (or its sheet's equivalent column, e.g. "Proority Count") to `LinkedIn-1`.
- New question text you write into a cell should go in as plain, unstyled text (matching the blank/default styling other recently-added stub rows use) — don't invent bold/italic/color for it.

## Updating existing questions

- If the matched row's Priority Count is blank/empty, set it to `LinkedIn-1`.
- If the matched row's Priority Count already holds a plain number (not a source tag), leave it untouched — don't overwrite numeric priority values.
- If the matched row's Priority Count already holds a `LinkedIn-N` style tag, and this txt file is a genuinely new/different source occurrence of that same question, increment it to `LinkedIn-(N+1)`. If it's the same tag from a source I've already had you process (i.e. you're re-running this check on the same txt content), leave it as-is — don't double-increment.
- Never touch Priority Count values that aren't yours to manage (e.g. pre-existing tags using a different source label, from unrelated earlier batches) unless they match a question actually present in this txt file.

## Company column

- The run's instruction may name a company (e.g. "These questions are from company 'Wipro'"). `DevOps_Prep.bat` asks for it up front, pre-filling it from a `Company: ...` line in `All_questions.txt` when there is one. If no company is named in the instruction, leave every Company cell untouched.
- When a company is named, write it into the Company column of every row this run adds or updates (Priority Count set or incremented — not rows left untouched or flagged):
  - Company cell blank → set it to the company name.
  - Company cell already holds other companies (comma-separated) and this one isn't among them (case-insensitive) → append `, <Company>`.
  - Company already listed → leave it.
- New-question rows get the company too, as plain unstyled text like the question cell.
- Header/metadata lines in the txt (`Company:`, `Role:`, `Experience Required:`, `Interview Mode:`, `Interview Date:`, section headings like `🔹 Kubernetes`) are not questions — don't match or add them. When cleaning up the txt, drop a section heading once no questions remain under it, and drop the metadata lines only once no questions remain in the file at all.

## Constraints

- Don't create a separate column for source/priority tracking — everything goes in the existing Priority Count column per sheet (and the company in the existing Company column).
- Don't introduce duplicate question rows — if a close match already exists anywhere in the workbook, update that row instead of adding a new one.
- Don't alter existing cell formatting anywhere in the workbook — this includes font, bold/italic, font color, fill/highlight color, borders, cell alignment, column widths, row heights, merged cells, and sheet order/names. Only add new rows or write into currently-blank cells; never re-touch a cell that already has a value or style, except the specific Priority Count and Company updates described above.
- **Preserve rich text (in-cell mixed formatting), not just whole-cell formatting.** Some cells may have *part* of their text bold, colored, a different size, etc. (e.g. a keyword bolded within an otherwise plain sentence) rather than the whole cell being styled uniformly. When you write to a cell that already contains text and rich-text runs (mixed formatting within the string), you must preserve those runs exactly as-is:
  - If you are only editing the Priority Count cell, this doesn't apply — that's a separate, likely-blank cell.
  - If a question cell itself needs any edit (which should be rare/none under this prompt, since existing question text shouldn't be touched), never do a plain overwrite of `cell.value` that would flatten mixed-run rich text down to a single uniform style. Use whatever your Excel-editing method supports for reading/writing rich text runs (e.g. preserving the `rich_text`/inline-string XML rather than round-tripping through a plain string), and if you can't guarantee runs will survive, stop and flag that cell instead of writing to it.
  - When appending brand-new rows, plain single-style text is fine (see "Adding new questions" above) — rich text only matters for cells that already contain mixed formatting.

## Cleaning up the txt file

- After the Excel workbook is successfully updated, remove from `All_questions.txt` only the questions that were confirmed added or updated (i.e. a clear match — new row created, or an existing row's Priority Count was set/incremented).
- Leave in the txt file any question that was only a borderline/loosely-related match and flagged for my confirmation — don't delete those until I've told you how to treat them.
- Do this edit only after the Excel save has been verified as successful (per the Safety checks below) — never remove a question from the txt file based on an Excel write you haven't confirmed took effect.

## Safety

- Before making any change, save a timestamped backup copy of the workbook (`bkp/excel/<workbook-filename>.BACKUP_before_<short-description>.xlsx`) so every run is recoverable.
- Check whether the workbook file is currently open/locked before writing; if it can't be safely written, stop and tell me instead of forcing it.
- Never insert rows in the middle of a sheet — only append new rows at the bottom. Never reorder, rename, or delete existing sheets, and never renumber existing Sr. No. values.
- After saving, verify the file isn't corrupted and that nothing was silently dropped or altered:
  - Check for mangled special characters (e.g. `�` replacing em dashes, arrows, or smart quotes) introduced by the edit.
  - Confirm charts, images, pivot tables, data validation, and conditional formatting (if any exist) are still intact.
  - Confirm rich text runs (mixed bold/italic/size/color within a single cell) on any cell you didn't intentionally rewrite are still present and unchanged. Don't settle for spot-checking a sample — count the total number of rich-text cells across the whole workbook before and after the save and require them to match exactly. A count mismatch (even if every cell you touched looks fine) means formatting was silently flattened somewhere else and must be investigated and restored from backup before proceeding, not waved through.
  - Never trust a row number taken from a text dump or grep output alone — several sheets can have the same row number with completely different content (a given row number means something different in each sheet). Before writing to any cell, confirm sheet name + row number + cell content together via a direct read of that exact cell, not just the line number from a search result.
- When checking whether a question is "already available," compare text case-insensitively and with leading/trailing/extra whitespace normalized, so near-identical formatting differences don't slip a duplicate past the check or wrongly flag a real match as missing.
- If anything looks abnormal after the edit (row/sheet counts don't match expectations, unexpected cells changed, file size or structure looks off, or rich text formatting lost on untouched cells), stop and report it rather than proceeding or auto-fixing.

## Report back

- After updating, give me a summary table: every txt question, its status (new row added / existing row updated / existing row left untouched because already numeric), which sheet+row it lives in, and its final Priority Count value. Flag anything you treated as a borderline match instead of silently deciding.
- Also give me a plain before/after diff of every cell actually changed (sheet, row, column, old value, new value) so I can verify the edits myself rather than just trusting the summary.
- If you had to skip a rich-text cell instead of editing it (per the Constraints above), call that out explicitly in the report so I know it needs manual handling.
