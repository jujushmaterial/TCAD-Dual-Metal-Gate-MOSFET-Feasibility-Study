---
layout: default
title: Reproducibility and Full TCAD Code
---

# 12. Reproducibility and Full TCAD Code

- [Navigation](./00_navigation.html)
- [Source code](../source/)
- [Results](../results/)
- [Current reproducibility guide](../appendix/reproducibility.html)

## Code Organization

| Code Set | Purpose | Status |
|---|---|---|
| [Presentation-stage DMG code](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/tree/main/source/coursework) | 최초 DMG SProcess/SDevice/SVisual 구현 | Final presentation baseline |
| [SiO₂ gate-leakage code](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/tree/main/source/verified/sio2_ig_baseline) | SiO₂ DMG + gate tunneling extraction | Verified successful run |
| [High-K and gate-ratio code](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/tree/main/source/verified/highk_eot1p6_gate_ratio) | High-K, ratio parameterization, corrected Vtgm, CC-DIBL | Main verified code |
| [Variable-EOT extension](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/tree/main/source/extended/highk_eot_sweep) | EOT 1.6/1.2/1.0 nm 확장 | Successful extension |

## Execution Order

```text
Workbench parameters
→ SProcess structure and TDR checkpoints
→ SDevice Low/High-Vd Id–Vg and Ig–Vg
→ SVisual metric extraction
→ DOE scalar table and CSV comparison
```

## Main Workbench Variables

- `Lg`, `DMG_Gap`, `DMG_RatioS`
- `NWell`
- `GOxTime`
- `LDD_Dose`, `LDD_E`
- `SD_Dose`, `SD_E`
- `Wf_S`, `Wf_D`
- `Vd_Low`, `Vd_High`
- `EOT_Target` in the extended code

## Reproducibility Boundary

공개된 command는 프로젝트에서 성공한 대표 세트의 전문입니다. 실행에는 Sentaurus license, Workbench node 연결, parameter registration과 input naming convention이 필요합니다. 결과의 absolute reproducibility는 tool version, material database, mesh와 server environment에 영향을 받을 수 있습니다.

## Data Files

- [Scaling baseline](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/results/scaling_baseline.csv)
- [Scaling selected conditions](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/results/scaling_selected_conditions.csv)
- [SiO₂ gate leakage](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/results/sio2_gate_leakage.csv)
- [High-K comparison](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/results/high_k_comparison.csv)
- [Gate-ratio trade-off](https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/results/gate_ratio_tradeoff.csv)

## AI Assistance

ChatGPT는 code 초안과 디버깅 방향, metric extraction logic, EOT calculation, 결과 비교와 발표 구성에 사용됐습니다. 생성된 code를 그대로 결과로 간주하지 않았고, 사용자가 Workbench에서 실행한 log, TDR, curve와 DOE output을 기준으로 성공 여부를 판단했습니다.
