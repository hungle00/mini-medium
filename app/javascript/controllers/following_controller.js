import { Modal } from "bootstrap";
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["modal"];
  static values = { url: String };

  connect() {
    console.log(this.urlValue)
    //.then(resp => resp.json())
    //.then(users => console.log(users))
  }

  show() {
    if(this.hasModalTarget) {
      console.log(modalTarget)
    } else {
      fetch(this.urlValue)
      .then(r => r.text())
      .then(html => {
        //console.log(html);
        const fragment = document.createRange().createContextualFragment(html);
        this.element.appendChild(fragment);
      });
    }
  }
}