(() => {
  const coreScript = document.createElement('script');
  coreScript.src = 'https://cdn.jsdelivr.net/gh/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study@4c8c3977ad33a185f524750635c4fce610bcc0cc/demo/assets/project-v2.js';
  coreScript.onerror = () => {
    console.error('프로젝트 페이지 코드 뷰어 스크립트를 불러오지 못했습니다.');
  };
  document.head.appendChild(coreScript);
})();
