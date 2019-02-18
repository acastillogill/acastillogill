# K-means clustering

The first step of the K-means clustering is to decide how many clusters do we want. This is because the first step of the algorithm is to initialise k-points at random positions, these are called cluster centroids. In a second step, the Euclidean distance between each observation and the centroid is calculated. Observations are assigned to the closest centroid. The third step is to move the centroids to the central points of the resulting clusters. Once this is done, the second and third step are repeated until the centroids don't move any further and the observations are no longer reassigned. 


```{r kmeans-clustering}

#K-means clustering with two clusters
km_cereals <- kmeans(dist_cereals, centers=7)

#Appending the clusters to all the dataset
cereals_km_clusters <- mutate(cereals, cluster=km_cereals$cluster)


kmeans_count <- count(cereals_km_clusters , cluster)

cereals_km_clusters  %>% 
  select(-shelf,-name,-mfr,-type)%>%
  group_by(cluster) %>% 
  summarise_all(funs(mean(.)))%>%
  cbind(kmeans_count$n)
```

```{r plot-kmeans}
 ggplot(cereals_km_clusters, aes(x = sugars, y = vitamins, color = factor(cluster))) +
  geom_point()+
  geom_text_repel(aes(label=name), force=2, size=3, segment.alpha = 0.5)+
  labs(title="Cluster assignement using seven-means",
       x="Sugar content per serving",
       y="Vitamins per serving")
  

```

# Estimating K empirically with the elbow method

This method tries to estimate the number of k's that we should have. It calculates the sum of the distances between each observation and the cluster corresponding to the observation to which each observation is assigned. 

```{r elbow-plot}
tot_withinss <- map_dbl(1:10, function(k){
  
  model <- kmeans(x=dist_cereals, centers=k)
  model$tot.withinss
  
})


elbow_df <- data.frame(
  
  k=1:10,
  tot_withinss=tot_withinss
  
)

ggplot(elbow_df, aes(x=k, y=tot_withinss)) +
  geom_line()+
  geom_point()+
  scale_x_continuous(breaks = 1:10)
```


# Estimating K empirically with silhouette analysis

The silhouette width is a measurement composed by the Within Cluster Distance (each observation to every other observation) and the Closest Neighbor Distance (the closest average distance from that observation to the points of the closest neighboring cluster).

```{r calculating-silhouettes}
sil_width <- map_dbl(2:10, function(k){
  
  model <- pam(x=dist_cereals, k=k)
  model$silinfo$avg.width
  
})

sil_df <- data.frame(
  
  k=2:10,
  
  sil_width=sil_width
  
)

ggplot(sil_df, aes(x=k, y=sil_width)) +
  geom_line()+
  geom_point()+
  scale_x_continuous(breaks = 1:10)
```

