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
    console.log("Messaging 3...")
    const current_user = this.currentUserIdTarget as HTMLInputElement;
    const consummer = createConsumer();

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
}
