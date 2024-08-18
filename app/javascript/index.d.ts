declare module 'el-transition' {
  function enter(el: HTMLElement, transitionName?: string): Promise<void>;
  function leave(el: HTMLElement, transitionName?: string): Promise<void>;
  function toggle(el: HTMLElement, transitionName?: string): Promise<void>;
}

// Dummy declaration for Turbo 8
declare module '@hotwired/turbo' {
  export class FrameElement extends HTMLElement {
    src: string | undefined;
    reload(): Promise<void>;
  }

  export type TurboFrameMissingEvent = CustomEvent<{
    response: Response;
  }>;

  interface StreamActionContext {
    hasAttribute(attributeName: string): boolean;
    templateContent: DocumentFragment;
    templateElement: HTMLTemplateElement;
    targetElements: Element[];
  }

  export namespace StreamActions {
    export let morph: (this: StreamActionContext) => void;
  }

  export function visit(url: string, options?): void;
}
