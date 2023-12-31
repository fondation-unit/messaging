import { Controller } from "@hotwired/stimulus";
import { createConsumer } from "@rails/actioncable";


export default class extends Controller {
  static targets = ["chatBox", "newMessageInput", "currentUserId", "newMessage"]

  declare chatBoxTarget: HTMLDivElement
  declare newMessageInputTarget: HTMLInputElement
  declare currentUserIdTarget: HTMLInputElement
  declare newMessageTarget: HTMLAreaElement

  connect() {
    const current_user = this.currentUserIdTarget as HTMLInputElement;
    const consummer = createConsumer();

    consummer.subscriptions.create({ channel: "MessageChannel", id: current_user.value }, {
      connected: () => {
        console.log("Connected to MessageChannel.");
      },
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
