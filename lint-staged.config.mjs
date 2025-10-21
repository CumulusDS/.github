/**
 * @file - Shared configuration for lint-staged.
 * @author - Jeff Beck.
 * @ref - https://www.npmjs.com/package/lint-staged
 * @ref - https://github.com/lint-staged/lint-staged
 * @packageDocumentation - https://github.com/lint-staged/lint-staged?tab=readme-ov-file#configuration
 */

import { asyncConfig } from "@cumulusds/lint-staged";

/**
 * @type  {import("lint-staged").Configuration}
 */
const config = {
  ...asyncConfig,
};

export default config;
