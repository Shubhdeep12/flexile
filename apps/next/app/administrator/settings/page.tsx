import { headers } from "next/headers";
import github from "@/lib/github";
import Settings from "./Settings";

export default async function SettingsPage() {
  const host = process.env.NODE_ENV === "production" ? "app.flexile.com" : (await headers()).get("Host");
  const { url } = github.getWebFlowAuthorizationUrl({
    redirectUrl: `https://${host}/oauth_redirect`,
    scopes: ["repo", "admin:org_hook"],
  });
  return <Settings githubOauthUrl={url} />;
}
