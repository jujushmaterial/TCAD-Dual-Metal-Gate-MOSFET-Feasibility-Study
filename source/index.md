---
layout: default
title: TCAD Source Code
---

# TCAD Source Code

프로젝트에서 사용한 Sentaurus command 전문을 발전 단계별로 공개합니다.

<div class="nav-links">
<a href="../appendix/reproducibility.html">Execution & Reproducibility</a>
<a href="../study/index.html">Full Study</a>
<a href="../results/index.html">Results</a>
<a href="../index.html">Project Page</a>
</div>

| Code set | Purpose | Status |
|---|---|---|
| [Initial coursework code](./coursework/README.html) | 최초 lateral DMG 구현 | Historical baseline |
| [SiO₂ DMG + gate leakage baseline](./verified/sio2_ig_baseline/README.html) | GateS/GateD tunneling extraction | Verified successful run |
| [High-K EOT 1.6 nm + gate ratio + reliable DIBL](./verified/highk_eot1p6_gate_ratio/README.html) | High-K, ratio, corrected Vtgm, CC-DIBL | Main verified set |
| [Variable-EOT extension](./extended/highk_eot_sweep/README.html) | EOT-dependent HfO₂ thickness calculation | Successful extension |

## Execution flow

```text
Workbench variables
→ SProcess and TDR checkpoints
→ SDevice Low/High-Vd Id–Vg and Ig–Vg
→ SVisual metric extraction
→ DOE scalar comparison
```

각 코드 세트의 목적, 필요한 파일, 관련 결과와 known limitation은 [Reproducibility guide](../appendix/reproducibility.html)에 정리했습니다.

<div class="warning">
공개 code는 프로젝트에서 사용한 representative command 전문입니다. 동일한 절대값 재현에는 Sentaurus T-2022.03, license, Workbench parameter registration, node dependency, mesh와 server environment가 필요합니다.
</div>
