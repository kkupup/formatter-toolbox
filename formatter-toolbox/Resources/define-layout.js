class GapLayout extends HTMLElement {
    constructor() {
        super();
    }

    connectedCallback() {
        const props = {
            width: this.hasAttribute('width') ? Number(this.getAttribute('width')) + 'px' : 'auto',
            height: this.hasAttribute('height') ? Number(this.getAttribute('height')) + 'px' : 'auto',
            direction: this.hasAttribute('direction') ? Number(this.getAttribute('direction')) : 'row',
            gap: this.hasAttribute('gap') ? Number(this.getAttribute('gap')) + 'px' : '10px',
            offsetTop: this.offsetTop,
            offsetLeft: this.offsetLeft,
        };
        let id = 'el_' + md5(new Date() + JSON.stringify(props));
        const style = document.createElement('style');
        style.textContent = `
            .${id} {
                width: ${props.width};
                height: ${props.height};
                display: flex;
                flex-direction: ${props.direction};
                align-items: center;
                gap: ${props.gap};
            }
        `;
        this.appendChild(style);
        this.classList.add(id);
    }
}

customElements.define('gap-layout', GapLayout);
