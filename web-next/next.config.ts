import type { NextConfig } from "next";

const isGithubPages = process.env.GITHUB_PAGES === "true";

const nextConfig: NextConfig = {
  output: "export",
  trailingSlash: true,
  devIndicators: false,
  basePath: isGithubPages ? "/drop4up" : undefined,
  assetPrefix: isGithubPages ? "/drop4up/" : undefined,
  images: {
    unoptimized: true,
  },
};

export default nextConfig;
