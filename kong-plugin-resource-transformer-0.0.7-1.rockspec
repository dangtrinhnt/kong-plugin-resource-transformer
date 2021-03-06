package = "kong-plugin-resource-transformer"
version = "0.0.7-1"
supported_platforms = {"linux", "macosx"}
source = {
   url = "git+ssh://github.com/MyMusicTaste/kong-plugin-resource-transformer",
   branch = "kong-1.5.0"
}
description = {
   summary = "> A kong plugin that will analyze the request path and transforms the ids.",
   detailed = "> A kong plugin that will analyze the request path and transforms the ids.",
   homepage = "https://github.com/MyMusicTaste/kong-plugin-resource-transformer",
   license = "MIT"
}
dependencies = {
  "lua >= 5.1"
}
build = {
   type = "builtin",
   modules = {
      ["kong.plugins.resource-transformer.access"] = "kong/plugins/resource-transformer/access.lua",
      ["kong.plugins.resource-transformer.api"] = "kong/plugins/resource-transformer/api.lua",
      ["kong.plugins.resource-transformer.daos"] = "kong/plugins/resource-transformer/daos.lua",
      ["kong.plugins.resource-transformer.handler"] = "kong/plugins/resource-transformer/handler.lua",
      ["kong.plugins.resource-transformer.migrations.000_base_resource_transformer"] = "kong/plugins/resource-transformer/migrations/000_base_resource_transformer.lua",
      ["kong.plugins.resource-transformer.migrations.init"] = "kong/plugins/resource-transformer/migrations/init.lua",
      ["kong.plugins.resource-transformer.schema"] = "kong/plugins/resource-transformer/schema.lua"
   },
   install = {
      bin = {}
   }
}
