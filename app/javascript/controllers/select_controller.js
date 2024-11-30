import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets() {
    return ["multiselect"];
  }

  multiselectElementTargetConnected() {
    $(this.multiselectTargets).select2({});
  }
}
