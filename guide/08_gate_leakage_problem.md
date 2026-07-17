---
layout: default
title: Gate Leakage Problem
---

# 08. Thin-SiO₂ Gate Leakage Problem

[← Navigation](./00_navigation.html) · [Gate Leakage CSV](../results/sio2_gate_leakage.csv)

## Why Drain Current Was Not Enough

Lg = 0.028 µm 구조의 SiO₂ gate dielectric은 약 1.6 nm였습니다. 초기 평가는 drain terminal의 Ioff와 DIBL에 집중했지만, 이 정도의 physical thickness에서는 direct tunneling에 의한 gate current가 total leakage의 중요한 성분이 될 수 있습니다.

![SiO2 gate leakage curve](../figures/leakage/sio2_gate_leakage_curve.svg)

## Tunneling Model Extension

SDevice에 gateS와 gateD 각각의 electrode-based NonLocal barrier tunneling mesh를 정의했습니다.

```text
IgTotal = |I(gateS)| + |I(gateD)|
```

SVisual은 off, operation point, on-state에서 `IgS`, `IgD`, `IgTotal`을 별도로 출력하도록 확장했습니다.

## SiO₂ Results at Lg = 0.028 µm

| Gate | Ioff (A/µm) | IgTotal_On, Low-Vd | IgTotal_On, High-Vd |
|---|---:|---:|---:|
| Single 4.2/4.2 eV | 2.22e-11 | 5.90e-9 | 2.79e-9 |
| Dual 4.2/4.8 eV | 2.90e-16 | 3.71e-9 | 1.89e-9 |

DMG는 drain-current 기반 Ioff를 크게 낮췄지만, on-state gate leakage는 여전히 `10^-9 A/µm` 수준으로 남았습니다.

<div class="callout">
따라서 “DMG로 leakage가 해결됐다”가 아니라, drain leakage를 줄인 뒤 gate dielectric leakage가 새로운 한계로 드러났다는 것이 정확한 해석입니다.
</div>
