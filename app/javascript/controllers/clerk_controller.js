import { Controller } from "@hotwired/stimulus";
import { initializeClerk, getClerk } from "init_clerk";

const CLERK_APPEARANCE = {
  variables: {
    colorBackground: "#212126",
    colorNeutral: "white",
    colorPrimary: "white",
    colorPrimaryForeground: "black",
    colorForeground: "white",
    colorInputForeground: "white",
    colorInput: "#26262B",
    fontFamily: "sans-serif",
  },
  elements: {
    providerIcon__apple: { filter: "invert(1)" },
    activeDeviceIcon: {
      "--cl-chassis-bottom": "#d2d2d2",
      "--cl-chassis-back": "#e6e6e6",
      "--cl-chassis-screen": "#e6e6e6",
      "--cl-screen": "#111111",
    },
  },
};
export default class extends Controller {
  static values = {
    userExists: Boolean,
  };
  static targets = ["message", "loading"];

  connect() {
    initializeClerk().then((clerk) => {
      const clerkNode = document.getElementById("clerk-node");
      clerkNode.innerHTML = '<div id="clerk-signup"></div>';

      if (clerk.isSignedIn) {
        this.signIn();
      } else {
        this.mountClerkSignUp(clerk);
      }

      // In development sso-callback in the path indicates we have received the callback and the page will reload
      // We don't show the auth message (just show "loading...") b/c the non-auth view was flashing up
      // since clerk wasn't initialized yet
      if (!window.location.toString().includes("sso-callback")) {
        this.showAuthMessage();
      }
    });
  }

  disconnect() {
    this.unmountClerkSignUp(getClerk());
  }

  signOut() {
    getClerk().signOut();
  }

  async signIn() {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;

    await fetch("/users/sign_in", {
      method: "PUT",
      headers: { "X-CSRF-Token": csrfToken },
    });
  }

  mountClerkSignUp(clerk) {
    const clerkSignUp = document.getElementById("clerk-signup");
    clerk.mountSignUp(clerkSignUp, {
      appearance: CLERK_APPEARANCE,
    });
  }

  unmountClerkSignUp(clerk) {
    const clerkSignUp = document.getElementById("clerk-signup");
    clerk.unmountSignUp(clerkSignUp);
  }

  showAuthMessage() {
    this.messageTarget.hidden = false;
    this.loadingTarget.hidden = true;
  }
}
