# Testing Kubernetes cluster network performance

A standardized benchmark to measure Kubernetes networking performance on multiple host platforms and network stacks.

### Usage
The test suite can be executed via a single Go binary that triggers all the automated testing present on the netperf Docker container. 

***NOTE*** A minimum of two Kubernetes worker nodes are necessary for this test. If using minikube you must enable the Docker registry as the image is needed on multiple hosts.

```shell
#create 2 node cluster
minikube start --nodes 2 --cpus=6 --memory=20019 --kubernetes-version=v1.21.0

#enable the docker registry and push image to make available on all nodes
minikube addons enable registry
docker run --rm -it --network=host alpine ash -c "apk add socat && socat TCP-LISTEN:5000,reuseaddr,fork TCP:$(minikube ip):5000" &
docker build ./docker -t netperf:latest
docker tag netperf:latest localhost:5000/netperf:latest
docker push localhost:5000/netperf:latest

#run the tests
cd docker && go run ./launch.go --iterations 1
```

### Kubernetes Network benchmark results
The tests will take some time, after ~35mins you should see the following output.

```shell
│ ALL TESTCASES AND MSS RANGES COMPLETE - GENERATING CSV OUTPUT                                                                                                                                                                                │
│ MSS                                          , Maximum, 96, 160, 224, 288, 352, 416, 480, 544, 608, 672, 736, 800, 864, 928, 992, 1056, 1120, 1184, 1248, 1312, 1376, 1440,                                                                  │
│ 1 iperf TCP. Same VM using Pod IP            ,43787.000000,40615,41787,41644,34696,38652,40741,39204,33203,39646,24538,43787,32438,27078,16714,33450,41896,35655,41853,40867,41655,40782,41521,                                              │
│ 2 iperf TCP. Same VM using Virtual IP        ,45900.000000,37386,36459,37758,40965,41688,38859,39247,41394,37100,35232,40901,35395,36015,41664,45293,44693,40741,42982,41322,44138,40716,45900,                                              │
│ 3 iperf TCP. Remote VM using Pod IP          ,27177.000000,26005,24857,26076,24670,24648,24399,24301,23858,23164,21852,24095,24304,25836,24940,25639,25975,22841,24274,24734,26783,24797,27177,                                              │
│ 4 iperf TCP. Remote VM using Virtual IP      ,26820.000000,24622,24673,24447,23553,22981,23879,23464,24202,25872,24083,26820,23440,25935,24738,25447,25284,23834,25140,24318,25430,24247,25509,                                              │
│ 5 iperf TCP. Hairpin Pod to own Virtual IP   ,43544.000000,38842,39599,38957,39019,39219,38770,39179,39829,41485,39045,43544,39219,38747,42666,40890,41004,37079,37665,37634,41949,37629,42241,                                              │
│ 6 iperf SCTP. Same VM using Pod IP           ,2547.000000,2472,2512,2505,2495,2502,2499,2531,1329,1653,1745,1568,1265,175,1259,506,484,2249,2135,2254,2332,2414,2547,                                                                        │
│ 7 iperf SCTP. Same VM using Virtual IP       ,2491.000000,2491,2451,2435,2441,2444,2429,2411,1229,1680,1490,1523,194,300,525,698,1557,1957,2119,2060,2250,2330,2408,                                                                         │
│ 8 iperf SCTP. Remote VM using Pod IP         ,1467.000000,1319,1416,1384,1361,1467,1462,1393,544,1073,1079,921,1020,844,1150,1103,382,1205,1352,1408,1422,1418,1437,                                                                         │
│ 9 iperf SCTP. Remote VM using Virtual IP     ,1540.000000,1438,1409,1216,1364,1534,1451,1540,948,863,1167,995,726,767,736,1240,1231,1191,1400,1441,1476,1441,1517,                                                                           │
│ 10 iperf SCTP. Hairpin Pod to own Virtual IP ,2356.000000,2236,2344,2300,2356,2309,2149,2146,1257,1476,1424,1378,807,364,954,1447,1409,1866,2025,2143,2210,1517,1131,                                                                        │
│ 11 iperf UDP. Same VM using Pod IP           ,4130.000000,4130,                                                                                                                                                                              │
│ 12 iperf UDP. Same VM using Virtual IP       ,3677.000000,3677,                                                                                                                                                                              │
│ 13 iperf UDP. Remote VM using Pod IP         ,1314.000000,1314,                                                                                                                                                                              │
│ 14 iperf UDP. Remote VM using Virtual IP     ,1281.000000,1281,                                                                                                                                                                              │
│ 15 netperf. Same VM using Pod IP             ,9016.800000,9016.80,                                                                                                                                                                           │
│ 16 netperf. Same VM using Virtual IP         ,0.000000,0,                                                                                                                                                                                    │
│ 17 netperf. Remote VM using Pod IP           ,7078.690000,7078.69,                                                                                                                                                                           │
│ 18 netperf. Remote VM using Virtual IP       ,0.000000,0,
```

### Understanding the benchmark data
More information and charting these results [Benchmarking Kubernetes Networking](https://github.com/kubernetes/perf-tests/tree/master/network/benchmarks/netperf#output-raw-csv-data)