import { Controller } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";
import { getCSRFToken, createFetchHeaders } from "../utils/csrf";
import { createConsumer } from "@rails/actioncable";


export default class extends Controller {
  static targets = ["chatBox", "form", "newMessageInput", "currentUserId", "newMessage"]

  declare chatBoxTarget: HTMLDivElement
  declare formTarget: HTMLFormElement
  declare newMessageInputTarget: HTMLInputElement
  declare currentUserIdTarget: HTMLInputElement
  declare newMessageTarget: HTMLAreaElement

  connect() {
    console.log("Messaging...")
    const current_user = this.currentUserIdTarget as HTMLInputElement;
    const consummer = createConsumer("ws://127.0.0.1:3000/cable");

    consummer.subscriptions.create({ channel: "MessageChannel", id: current_user.value }, {
      connected: () => { },
      received: (data) => {
        if (!data.includes("class=\"list-item self")) {
          this.newMessageTarget.classList.remove("d-none");
          this.newMessageTarget.classList.add("d-flex");
        }

        // In all cases, scroll to bottom
        setTimeout(() => {
          this.scrollToBottom()
        }, 200);
      }
    });

    this.scrollToBottomOnLoad();

    this.newMessageTarget.addEventListener("click", () => {
      this.scrollToBottom();
      this.newMessageTarget.classList.remove("d-flex");
      this.newMessageTarget.classList.add("d-none");
    });

    this.formTarget.addEventListener("onsubmit", (event) => {
      event.preventDefault();
      event.stopPropagation();

      return false;
    });

    this.formTarget.addEventListener("submit", (event) => {
      console.log("2:", this.formTarget)
      event.preventDefault();
      event.stopPropagation();

      this.createMessage();

      return false;
    });
  }

  scrollToBottom() {
    if (this.chatBoxTarget instanceof HTMLElement) {
      this.chatBoxTarget.scrollTop = this.chatBoxTarget.scrollHeight;
    }
  }

  scrollToBottomOnLoad() {
    document.addEventListener("DOMContentLoaded", () => {
      this.scrollToBottom();
    });
  }

  createMessage() {
    const csrfToken = getCSRFToken();
    const headers = createFetchHeaders(csrfToken);
    const body = this.formTarget.querySelector("#message-body") as HTMLInputElement;
    const userId = this.formTarget.querySelector("#message_user_id") as HTMLInputElement;
    const pathname = window.location.pathname

    fetch(`${pathname.includes('/admin') ? '/admin/messages' : '/messages'}`, {
      method: "POST",
      mode: "cors",
      cache: "no-cache",
      credentials: "same-origin",
      headers,
      body: JSON.stringify({ body: body.value, user_id: userId.value })
    })
      .then(response => response.text())
      .then(data => {
        Turbo.renderStreamMessage(data)
        this.newMessageInputTarget.value = "";
        this.chatBoxTarget.scrollTop = this.chatBoxTarget.scrollHeight;

        return true;
      });

    return false;
  }
}
