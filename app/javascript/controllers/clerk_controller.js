import { Clerk } from "@clerk/clerk-js";
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  constructor() {
    super();
    const clerkKey = document.querySelector(
      'meta[name="clerk_publishable_key"]'
    ).content;
    this.clerk = new Clerk(clerkKey);
    this.clerk.load().then(() => {
      if (this.clerk.isSignedIn) return;

      const clerkNode = document.getElementById("clerk-node");
      this.clerk.mountSignUp(clerkNode, {
        appearance: {
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
        },
      });
    });
  }

  // NOTE: This is how we sign out
  async signOut() {
    await this.clerk.signOut();
  }
}
