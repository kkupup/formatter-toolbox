class GapLayout extends HTMLElement {
    constructor() {
        super();
    }

    connectedCallback() {
        let width = this.hasAttribute('width') ? Number(this.getAttribute('width')) + 'px' : 'auto';
        let height = this.hasAttribute('height') ? Number(this.getAttribute('height')) + 'px' : 'auto';
        let gap = Number(this.getAttribute('gap')) || 10;
        // row, column
        let direction = Number(this.getAttribute('direction')) || 'row';
        let id = String.fromCharCode(97 + Math.ceil(Math.random() * 25)) + md5(new Date() + width + height + gap + direction);

        const style = document.createElement('style');
        style.textContent = `
            .${id} {
                width: ${width};
                height: ${height};
                display: flex;
                flex-direction: ${direction};
                align-items: center;
                gap: ${gap}px;
            }
        `;
        this.appendChild(style);
        this.classList.add(id);
    }
}

customElements.define('gap-layout', GapLayout);
