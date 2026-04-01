
# Workflow Model

---

## States

- idle
- ready
- processing
- completed

---

## Flow

1. User selects document
2. State → ready
3. User triggers workflow
4. State → processing
5. Mock delay
6. State → completed

---

## Future Extensions

- cancellation
- error states
- retry
- multi-stage pipeline