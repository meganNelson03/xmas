import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    Turbo.config.forms.confirm = (message, element) => {
      const dialog = this.insertConfirmModal(message, element);
    
      return new Promise((resolve) => {
        dialog.querySelector("[data-behavior='cancel']").addEventListener("click", () => {
          dialog.remove();

          $('.modal').has('.modal-dialog').first().modal('show')

          resolve(false);
        }, { once: true })
        dialog.querySelector("[data-behavior='commit']").addEventListener("click", () => {
          dialog.remove();

          $('.modal').has('.modal-dialog').first().modal('show')
  
          resolve(true);
        }, { once: true })
      })
    }
  }

  insertConfirmModal(message, element) {
    var content = `
    <div id="confirm-modal">
    <div class="modal fade" data-bs-backdrop="static" data-bs-keyboard="false">
    <div class="modal-dialog modal-dialog-centered modal-lg view-modal-dialog">
      <div class="modal-content">
      <div class="modal-body mt-4">
        <div class='warning'>
          ${message}
        </div>
        <div class="d-flex justify-content-center mt-4">
          <button data-behavior="cancel" data-bs-dismiss="modal" class='btn btn-default cancel me-3'>Cancel</button>
          <button data-behavior="commit" data-bs-dismiss="modal" class='btn input accept'>Yes, delete this</button>
        </div>
      </div>
      </div>
    </div>
    </div>
    </div>
    `
    $('.modal').has('.modal-dialog').first().modal('hide');

    document.body.insertAdjacentHTML('beforeend', content);
     
    $('#confirm-modal .modal').modal('show')
    document.activeElement.blur();
  
    return document.getElementById("confirm-modal");
  }
}
