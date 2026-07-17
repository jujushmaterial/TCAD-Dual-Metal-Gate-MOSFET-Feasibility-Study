(() => {
  const content = document.querySelector('.document-content');
  if (!content) return;

  const repositoryBase = '/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/';

  // Normalize every repository figure path without depending on the current
  // document depth. This covers Markdown-rendered relative paths as well as
  // already-normalized browser paths.
  content.querySelectorAll('img').forEach((image) => {
    const source = image.getAttribute('src') || '';
    if (!source || /^(?:data:|https?:\/\/)/i.test(source)) return;

    const figureMarker = 'figures/';
    const markerIndex = source.indexOf(figureMarker);
    if (markerIndex < 0) return;

    const figurePath = source.slice(markerIndex);
    image.setAttribute('src', `${repositoryBase}${figurePath}`);
  });

  const redundantLabels = [
    '프로젝트 첫 페이지',
    '발표 흐름으로 정리한 전체 연구',
    '발표 흐름으로 읽는 전체 연구',
    '← 전체 연구'
  ];

  const isRedundant = (text) => redundantLabels.some((label) => text.trim() === label);

  [...content.querySelectorAll('a')].forEach((link) => {
    if (!isRedundant(link.textContent || '')) return;
    const item = link.closest('li');
    if (item) {
      const list = item.parentElement;
      item.remove();
      if (list && !list.querySelector('li')) list.remove();
      return;
    }

    const parent = link.parentElement;
    link.remove();
    if (parent && !parent.textContent.trim() && !parent.querySelector('*')) parent.remove();
  });

  // Remove only genuinely empty paragraphs. Markdown wraps standalone images
  // in <p> elements, so deleting every text-empty paragraph also deleted the
  // research figures. Preserve paragraphs containing any meaningful element.
  [...content.querySelectorAll('p')].forEach((paragraph) => {
    const text = paragraph.textContent.replace(/[·|]/g, '').trim();
    const hasMeaningfulElement = paragraph.querySelector(
      'img, picture, figure, video, iframe, svg, canvas, pre, code, table, a, button'
    );

    if (!text && !hasMeaningfulElement) paragraph.remove();
  });
})();
