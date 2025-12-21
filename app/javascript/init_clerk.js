import { Clerk } from "@clerk/clerk-js";

let clerkInstance = null;
let clerkPromise = null;

export async function initializeClerk() {
  if (clerkInstance) return clerkInstance;

  if (clerkPromise) return clerkPromise;

  const publishableKey = document.querySelector(
    'meta[name="clerk-publishable-key"]'
  )?.content;

  if (!publishableKey) {
    console.warn("Clerk publishable key not found");
    return null;
  }

  clerkPromise = (async () => {
    const clerk = new Clerk(publishableKey);
    await clerk.load();
    clerkInstance = clerk;

    return clerk;
  })();

  return clerkPromise;
}

export function getClerk() {
  return clerkInstance;
}

export function isClerkLoaded() {
  return clerkInstance !== null;
}
