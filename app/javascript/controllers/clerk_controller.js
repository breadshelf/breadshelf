import { Clerk } from "@clerk/clerk-js";
import { Controller } from "@hotwired/stimulus";

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

  initialize() {
    fetch("/api/vars").then(async (response) => {
      if (!response.ok) return;

      const result = await response.json();
      this.clerk = new Clerk(result.clerkPublishableKey);

      this.clerk.load().then(() => {
        this.clerk.addListener(async (state) => {
          // sign in when a user exists
          if (state.user) {
            await this.signIn();
          } else {
            this.renderClerkSignUp();
          }
        });
      });
    });
  }

  async signOut() {
    await this.clerk.signOut();
  }

  async signIn() {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;

    await fetch("/users/sign_in", {
      method: "PUT",
      headers: { "X-CSRF-Token": csrfToken },
    });
  }

  renderClerkSignUp() {
    const clerkNode = document.getElementById("clerk-node");
    this.clerk.mountSignUp(clerkNode, {
      appearance: CLERK_APPEARANCE,
    });
  }
}
