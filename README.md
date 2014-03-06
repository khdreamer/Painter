架構：  

>backend  
>>連到 node.js (使用 express)，將所需的前端檔案回傳給瀏覽器。需要 server 的原因是需要讀取 processing.js。  

>frontend  
>>html 裡面的 canvas 包著 processing.js，大部分繪圖 function 都是 processing.js 實做的。UI 部份有用到 jQuery 和 jQuery UI。 

實做的功能 

>最開始可以選擇畫布大小 
>鉛筆：可以調整筆刷大小 
>橡皮擦：不是塗上背景色，而是將塗過範圍變為透明。也可以調整大小 
>噴槍：因為使用極座標，中心會比較密。可以調整大小與密度 
>放大縮小：可以把整張畫布放大縮小  
>拖移：可以把畫布拖來拖去  
>圖層：  
>>新增圖層：預設的第一個圖層是白色背景，新圖層是透明背景 
>>刪除圖層  
>>改變圖層順序  
  
使用方式  

>先安裝用到的 packages 
    npm install 
>開起來 
    node app.js  