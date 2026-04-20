local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"oauth2",
		fmt(
			[[
const axios = require("axios");

async function oauthToken({tokenUrl}, clientId, clientSecret, scope = "{scope}") {{
  const params = new URLSearchParams();
  params.append("grant_type", "client_credentials");
  params.append("client_id", clientId);
  params.append("client_secret", clientSecret);
  params.append("scope", scope);

  const res = await axios.post(tokenUrl, params);
  return res.data.access_token;
}}

module.exports = oauthToken;
  ]],
			{
				tokenUrl = ls.insert_node(1, "https://auth.example.com/oauth/token"),
				scope = ls.insert_node(2, "api.read"),
			}
		)
	),
}
