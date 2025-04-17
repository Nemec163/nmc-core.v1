import type { NextConfig } from "next";
import path from "path";

const nextConfig: NextConfig = {
  /* config options here */
  webpack: (config) => {
    config.resolve.alias = {
      ...config.resolve.alias,
      "@nmc/ui": path.resolve(__dirname, "../../packages/nmc-ui.v1/src"),
    };
    return config;
  },
};

export default nextConfig;
