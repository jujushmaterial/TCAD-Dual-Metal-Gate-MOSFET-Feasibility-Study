---
layout: default
title: Reproducibility and Full TCAD Code
---

# 12. Reproducibility and Full TCAD Code

[← Navigation](./00_navigation.html) · [Source Index](../source/README.html) · [Raw Results](../results/README.html)

## Code Organization

| Code Set | Purpose | Status |
|---|---|---|
| `source/coursework/` | 최초 DMG SProcess/SDevice/SVisual 구현 | Historical baseline |
| `source/verified/sio2_ig_baseline/` | SiO₂ DMG + gate tunneling extraction | Verified successful run |
| `source/verified/highk_eot1p6_gate_ratio/` | High-K, ratio parameterization, corrected Vtgm, CC-DIBL | Main conference code |
| `source/extended/highk_eot_sweep/` | EOT 1.6/1.2/1.0 nm 확장 | Successful extension, not central conference result |

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
- `LDD_Dose`, `LDD_E`
- `SD_Dose`, `SD_E`
- `Wf_S`, `Wf_D`
- `Vd_Low`, `Vd_High`
- `EOT_Target` in the extended code

## Reproducibility Boundary

공개된 command는 프로젝트에서 성공한 대표 세트의 전문입니다. 다만 실행에는 Sentaurus license, Workbench node 연결, parameter registration, input naming convention이 필요합니다. 결과의 absolute reproducibility는 tool version, material database, mesh, server environment에 영향을 받을 수 있습니다.

## Data Files

- `scaling_baseline.csv`
- `scaling_selected_conditions.csv`
- `sio2_gate_leakage.csv`
- `high_k_comparison.csv`
- `gate_ratio_tradeoff.csv`

## AI Assistance

ChatGPT는 code 초안과 디버깅 방향, metric extraction logic, EOT calculation, 결과 비교와 발표 구성에 사용됐습니다. 생성된 code를 그대로 결과로 간주하지 않았고, 사용자가 Workbench에서 실행한 log, TDR, curve와 DOE output을 기준으로 성공 여부를 판단했습니다.
