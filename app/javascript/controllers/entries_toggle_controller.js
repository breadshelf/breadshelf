import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["authorField", "toggleButton"];

  toggle() {
    const isHidden = this.authorFieldTarget.hidden;
    this.authorFieldTarget.hidden = !isHidden;
    
    // Update arrow rotation based on state
    if (isHidden) {
      this.toggleButtonTarget.classList.add("open");
    } else {
      this.toggleButtonTarget.classList.remove("open");
    }
  }
}
