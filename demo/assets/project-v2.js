(() => {
  const applyProjectSummary = () => {
    const summary = document.querySelector('.hero-visual__summary');
    if (!summary) return;

    summary.innerHTML = `
      <h2>프로젝트 요약</h2>
      <dl>
        <div>
          <dt>개요</dt>
          <dd>기존 Single-Metal Gate를 source 측 low-WF GateS와 drain 측 high-WF GateD로 분리해, source–drain 방향의 work-function engineering이 소자 물리 성능에 미치는 영향을 비교 검증한 실험입니다.</dd>
        </div>
        <div>
          <dt>목적</dt>
          <dd>향후 실제 공정 Process 연구에 앞서 Dual-Metal Gate의 물리적 우수성과 source injection·drain suppression 역할 분리 가능성을 Sentaurus TCAD로 확인했습니다.</dd>
        </div>
        <div>
          <dt>결과</dt>
          <dd>세 gate length에서 Ion의 소폭 감소와 함께 Ioff 감소 및 Ion/Ioff 증가 방향을 반복 확인했으며, High-K stack 적용 시 동일 EOT 조건에서 IgTotal을 약 99.40% 줄였습니다.</dd>
        </div>
      </dl>`;
  };

  const applyResourceLabels = () => {
    const labels = {
      'Full Study': '연구 자세히 보기',
      'Presentation': '최종 보고서',
      'Source Code': 'TCAD 코드 확인',
      'Results': '연구 진행 Data',
      'Reproducibility': '연구 재현',
      'References': '참고문헌'
    };

    document.querySelectorAll('.resource-list > a, .resource-list > button').forEach((item) => {
      const title = item.querySelector('strong')?.textContent?.trim();
      const description = item.querySelector('span');
      if (title && description && labels[title]) description.textContent = labels[title];
    });
  };

  const applyStatusPolicy = () => {
    const status = document.querySelector('.status');
    if (!status) return;

    [...status.childNodes].forEach((node) => {
      if (node.nodeType === Node.TEXT_NODE) node.remove();
    });
    status.append(' Complete');
  };

  const applyPageText = () => {
    applyProjectSummary();
    applyResourceLabels();
    applyStatusPolicy();
  };

  applyPageText();

  const coreScript = document.createElement('script');
  coreScript.src = 'https://cdn.jsdelivr.net/gh/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study@4c8c3977ad33a185f524750635c4fce610bcc0cc/demo/assets/project-v2.js';
  coreScript.onload = applyPageText;
  coreScript.onerror = () => {
    console.error('프로젝트 페이지 핵심 스크립트를 불러오지 못했습니다.');
  };
  document.head.appendChild(coreScript);
})();
