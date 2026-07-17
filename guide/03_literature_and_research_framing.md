---
layout: default
title: Literature and Research Framing
---

# 03. Literature and Research Framing

[← Navigation](./00_navigation.html) · [Full Bibliography](../references/bibliography.html)

## Why Work-Function Engineering Still Matters

GAA nanosheet는 gate electrostatic control을 강화하지만, high-performance와 low-power library를 위해 여러 threshold-voltage option이 필요합니다. Literature review에서는 WFM modification, WFM volume/thickness, dipole-based gate stack과 같은 전기적 조절 방법이 함께 연구됨을 확인했습니다.

동시에 nanosheet 사이 공간이 제한되기 때문에 WFM deposition과 etch-back이 어려워지고, non-uniform WFM은 Vth variability를 유발할 수 있습니다. 따라서 WFM engineering은 **필요성과 공정 난이도가 동시에 존재하는 연구 영역**입니다.

## Evidence Layers

| Evidence | Role in This Portfolio |
|---|---|
| GAA process reviews | Multi-Vt와 WFM engineering 필요성, 공간·variability 한계 |
| CGAA DMG simulations | DMG와 gate-length partition이 DIBL에 영향을 줄 수 있다는 물리 근거 |
| Split-gate CFET demonstrations | Dual-WFM이 최신 CFET integration과 Vt tuning에 사용되는 실증 근거 |
| High-K reviews | 동일 EOT에서 물리 두께를 늘려 tunneling을 낮추는 재료·공정 배경 |

## Research Position

![Technology context](../figures/concept/technology_context.svg)

본 연구의 2D planar 결과는 GAA·CFET fabrication을 증명하지 않습니다. 역할은 다음과 같습니다.

```text
Complex 3D WFM integration problem
→ isolate the electrostatic hypothesis
→ verify Work-Function Split in a 2D test vehicle
→ identify leakage and extraction limitations
→ define the next 3D/process-validation questions
```

## Core References

- Mukesh & Zhang (2022): GAA nanosheet process opportunities, Multi-Vt and WFM challenges
- Sanjay et al. (2020, 2024): CGAA dual-material/dual-metal gate simulation and DIBL analysis
- Zhang et al. (IEDM 2017): HKMG and Multi-Vt options for stacked nanosheet GAA
- Arimura et al. (VLSI 2024): GAA Vt fine-tuning compatible with CFET integration
- Huang et al. (IEDM 2024), Liu et al. (IEEE TED 2025): split-gate CFET dual-WFM integration and Vt tuning
- Robertson & Wallace (2015): High-K/metal-gate material and leakage background

논문 원문은 저작권을 존중해 무단 재배포하지 않고 DOI와 공식 출판사 링크로 연결했습니다.
