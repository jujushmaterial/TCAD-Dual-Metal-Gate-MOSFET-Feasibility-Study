# Asset Mapping for Repository Redesign

이 폴더는 `jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study` 저장소 루트에 업로드할 자산입니다.

## Actual Sentaurus assets

| Repository path | Source / interpretation | Intended use |
|---|---|---|
| `figures/actual/scaling/lg_0p25_transfer_curve.png` | n318 Low/High-Vd Id-Vg | Lg = 0.25 um 검증 |
| `figures/actual/scaling/lg_0p25_final_device.png` | n318 final device | Lg = 0.25 um final structure |
| `figures/actual/scaling/lg_0p25_gate_cap_removed.png` | JH_n318_12 gate-cap-removed checkpoint | GateS/GateD material visibility |
| `figures/actual/process/dmg_sprocess_montage_lg_0p25.png` | n318 process checkpoint montage | SProcess implementation flow |
| `figures/actual/scaling/lg_0p10_transfer_curve.png` | n176 Low/High-Vd Id-Vg | Lg = 0.10 um 검증 |
| `figures/actual/scaling/lg_0p10_final_device.png` | n176 final device | Lg = 0.10 um final structure |
| `figures/actual/scaling/lg_0p10_gate_cap_removed.png` | JH_n176_12 gate-cap-removed checkpoint | GateS/GateD material visibility |
| `figures/actual/scaling/lg_0p028_transfer_curve.png` | n264 Low/High-Vd Id-Vg | Lg = 0.028 um 검증 |
| `figures/actual/scaling/lg_0p028_final_device.png` | n264 final device | Lg = 0.028 um final structure |
| `figures/actual/scaling/lg_0p028_gate_cap_removed.png` | JH_n264_12 gate-cap-removed checkpoint | GateS/GateD material visibility |

## Presentation-based assets

- Slides 2, 9, 10, 12, and 16-24 are exported from the final conference presentation.
- Slides 13-15 additionally provide separate crops for baseline data, parameter screening, and selected conditions.
- The slide crops are evidence of the actual presentation flow; they are not newly invented diagrams.

## Final presentation

- `presentation/final_conference_presentation.pdf`: browser-viewable final deck
- `presentation/final_conference_presentation.pptx`: original editable/downloadable deck

## Data-stage warning

The repository text must keep these stages separate:

1. Scaling baseline and selected conditions from Slides 13-16
2. Leakage-follow-up geometry/data from Slide 17
3. High-K comparison from Slides 18-19
4. Gate-ratio study from Slides 20-23
5. Post-presentation corrected-Vtgm / constant-current validation

Do not merge the Slide 15 Lg = 0.028 values with the later Slide 17 leakage-follow-up values as though they were one unchanged condition.
