/**
 * @file  - Shared configuration for eslint.
 * @author  -  Jeff Beck.
 * @ref  -  https://www.npmjs.com/package/eslint
 * @ref  -  https://github.com/eslint/eslint
 * @packageDocumentation  -  https://eslint.org/docs/latest/
 */

import { defineConfig } from "eslint/config";
import baseConfig from "@cumulusds/eslint";

/**
 * @type  {import("eslint").Config}
 */
export default defineConfig([baseConfig]);
