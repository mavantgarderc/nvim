local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "skclus",
    name = "scikit-learn Clusterer Class Docstring",
    desc = "Full docstring for a scikit-learn clusterer (e.g., KMeans).",
  }, {
    t({ '"""', "" }),
    i(1, "K-Means clustering."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "" }),
    i(2, "n_clusters : int, default=8"),
    t({ "", "    The number of clusters to form as well as the number of centroids to generate." }),
    t({ "", "", "Attributes", "----------" }),
    t({ "", "" }),
    i(3, "cluster_centers_ : ndarray of shape (n_clusters, n_features)"),
    t({ "", "    Coordinates of cluster centers." }),
    t({ "", "inertia_ : float" }),
    t({ "", "    Sum of squared distances of samples to their closest cluster center." }),
    t({ "", "n_iter_ : int" }),
    t({ "", "    Number of iterations run." }),
    t({ "", "", "Methods", "-------" }),
    t({ "", "fit(X[, sample_weight])" }),
    t({ "", "    Compute k-means clustering." }),
    t({ "", "predict(X)" }),
    t({ "", "    Predict the closest cluster each sample in X belongs to." }),
    t({ "", "fit_predict(X[, sample_weight])" }),
    t({ "", "    Compute cluster centers and predict cluster index for each sample." }),
    t({ "", '"""' }),
  }),
}
