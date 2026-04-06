# DizzyFlow Term Table

This document is the canonical terminology source for DizzyFlow user-facing product language.

It defines approved English-to-Korean terminology for UI, workflow, and settings surfaces.

All agents and contributors must consult this file before introducing or revising product-facing terms.

## Rules

- English is the canonical source language for product terminology.
- Korean does not require literal one-to-one translation.
- English-derived loanwords are allowed when they are more natural, recognizable, or stable in product UI.
- One concept must keep one approved UI rendering unless the policy is explicitly revised.
- If a new product term is introduced, this table must be updated in the same change.
- Korean workflow and status language should prioritize user-friendly state expressions over literal label translation.
- When a term appears in both compact label form and full status sentence form, both forms should be documented explicitly.
- Agents must not improvise alternate Korean endings for the same workflow state without updating this table.

## Korean Status Style Rule

For Korean UI, workflow state expressions should be written in forms that clearly communicate current condition to the user.

Preferred guidance:

- compact labels may remain short
- status sentences should read naturally as user-facing product copy
- in-progress states should clearly indicate ongoing activity
- completed states should clearly indicate finished result
- cancelled and failed states should clearly indicate terminal outcome

Preferred examples:

- Processing -> 처리 중
- Processing (status sentence) -> 처리 중입니다...
- Completed -> 완료
- Completed (status sentence) -> 완료되었습니다
- Failed -> 실패
- Failed (status sentence) -> 실패했습니다
- Cancelled -> 취소됨
- Cancelled (status sentence) -> 취소되었습니다

Notes:

- use compact label forms where UI space is tight
- use sentence forms where the interface presents workflow status as feedback text
- avoid mixing multiple Korean variants for the same state across screens

## Columns

- Canonical Term: approved English source term
- Approved Korean (Label): approved compact Korean UI form
- Approved Korean (Status): approved Korean sentence-style status form when applicable
- Rule: translation, borrowing, or usage rule
- Notes: optional usage notes, scope, or exceptions

| Canonical Term | Approved Korean (Label) | Approved Korean (Status) | Rule | Notes |
|---|---|---|---|---|
| Workflow | 워크플로우 | - | English-derived term allowed | Preferred over forced native translation |
| Subtitle Document | 자막 문서 | - | Product translation | Use in document-centered workflow surfaces |
| Processing | 처리 중 | 처리 중입니다... | Fixed status term | Use label form for badges, sentence form for ongoing workflow feedback |
| Ready | 준비 완료 | 처리할 준비가 되었습니다 | Fixed status term | Prefer more natural status sentence over literal form |
| Completed | 완료 | 완료되었습니다 | Fixed status term | Phase label and completion feedback |
| Failed | 실패 | 실패했습니다 | Fixed status term | Terminal state wording |
| Cancelled | 취소됨 | 취소되었습니다 | Fixed status term | Prefer clear terminal wording |
| Settings | 설정 | - | Standard UI term | Global settings surface |
| General | 일반 | - | Standard UI term | Settings category |
| Program Language | 프로그램 언어 | - | Standard UI term | Settings > General |
| Model | 모델 | - | English-derived term allowed | Preferred UI term |
| Inspector | 인스펙터 | - | English-derived term allowed | Preferred over forced literal translation |
| Preprocessor | 전처리 | - | Product translation | Use consistently |
| VAD | VAD | - | Keep source acronym | Do not localize acronym |
| Support Region | 지원 영역 | - | Fixed product term | Use consistently in UX documentation |
| Action Row | 액션 행 | - | English-derived term allowed | Use consistently in UX documentation |
| BottomControlStack | BottomControlStack | - | Keep source identifier | Internal component name referenced in docs |

## Change Rule

When adding a new term:

1. confirm it is a true product term
2. check whether an existing canonical term already covers it
3. decide whether both label form and status sentence form are required
4. add the term with approved Korean and rule
5. update related localization resources in the same change

## Related Documents

- `AGENT.md`
- `docs/ux/localization.md`
- `docs/development.md`
