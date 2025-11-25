local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "npmlclus",
    name = "NumPy ML Clustering Model Docstring",
    desc = "NumPy-style docstring for a clustering model class (e.g., KMeans).",
  }, {
    t({ '"""', "" }),
    i(1, "K-Means clustering."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "n_clusters : int, default=8" }),
    t({ "", "    The number of clusters to form." }),
    t({ "", "init : {'k-means++', 'random'}, default='k-means++'" }),
    t({ "", "    Method for initialization." }),
    t({ "", "", "Attributes", "----------" }),
    t({ "", "cluster_centers_ : ndarray, shape (n_clusters, n_features)" }),
    t({ "", "    Coordinates of cluster centers." }),
    t({ "", "labels_ : ndarray, shape (n_samples,)" }),
    t({ "", "    Labels of each point." }),
    t({ "", "", "Methods", "-------" }),
    t({ "", "fit(X)" }),
    t({ "", "    Compute k-means clustering." }),
    t({ "", "predict(X)" }),
    t({ "", "    Predict the closest cluster each sample in X belongs to." }),
    t({ "", '"""' }),
  }),
}
