# Twitter API - PS5 Tweets Analysis

![twiiter_PS5](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.MsXmkzRTiCJU5Dxm7a0SJQHaDt%26pid%3DApi&f=1)

## Objective :
To track customer reactions of PS5 launched on Nov 12, 2020 through Twitter for the period of 4 days (15/01/2021-18/01/2021)

## Key findings:
1) Evening time has the highest amount of tweets of PS5 when twitter users are more active.
2) Majority of PS5 tweets are from the US or the UK, especially in London and California
3) Over 85% of PS5 tweets come from different platforms of Twitter, the rest are from 
   official PlayStation and third-party social media management service providers.
4) The main topic of PS5 is about gaming, some of the most frequently used words are
   about PS5 itself directly and the competitors.
5) The hashtags that appear frequently are related to PS5 device and its competitors, 
   game streaming, and name of the games.
6) In general, there‘re more negative emotions than positive ones on our Twitter dataset.
7) Most of the positive words expressed user's support for the PS5 launch.
8) Negative emotions are more about insufficient stock of PS5 and some product issues.

## Dataset :

The data was collected using Twitter API. This dataset cover 4962 tweets with the keyword "Playstation 5 OR PlayStation 5 OR playstation5 OR PS5 OR PS5Share OR ps5" from 15/01/2021 to 18/01/2021.

Only location, source, text columns were used in this project.


## Analysis : 

### Location of PS5 Tweets :
![location](/images/location_tweets.png)  
Most of the PS5 tweets are from UK and the US. In UK, England has more people talking about 'PS5' specifically, followed by London.  
Looking deep into the US, California ranks the 5th globally and the first in the US. Texas and New York States have similar number of tweets of PS5 at around 70. We can also see tweets of PS5 from Canada, Australia, Italy, and some other Asian countries but they account for less than 50 tweets respectively.

### Posting Time of PS5 Tweets : 
<img src="/images/Frequency_of_tweet.png" width="400">  
In general, 'PS5' becomes less popular over 4 days(15/01/2021-18/01/2021) as there is a flat downward trend over this period of time. Evening time has the highest amount of tweets of PS5. Twitter users are more active from 19:00 to 03:00. Oppositely, the morning period (03:00 to 11:00) has the lowest volume of tweets posted.

### Source of PS 5 Tweets :
<img src="/images/source_PS5.png" width="400">  
Most of the tweets originate from Twitter for iPhone, for Android and Web App. 6.48% tweets are from PlayStation@Network which could be linked with the social media accounts such as Twitter, Facebook, and YouTube. Also, around 8% of tweets are from third-party service providers which help to manage their social media accounts with automatically posting tweets service. Dlvr.it, IFTTT and Salesforce - Social Studio are the providers found for PS5 tweets which could possibly be the advertisement of PS5.

### Most Frequent Hashtags : 
<img src="/images/hashtags.png" width="500">    
Beside the hashtags directly related to 'Playstation5', the most frequently used tag is Xbox which is the competitor of PlayStation. The hashtags can be categorized into three:  

1. Competitors (other consoles, e.g. Xbox, Switch from Nintendo)  
2. Games of PS5( e.g.GTA, COD (Call of Duty) Cold war)  
3. Game streaming(e.g. streamer, ps4live, youtube)  

### Sentiment of PS5 Tweets : 
<img src="/images/sentiment_PS5.png" width="500">   
In general, there are more than negative emotions (red) than positive emotions (green). The negative emotions score, 336, was higher than the positive emotions score, 289. While trust was the highest ranking sentiment at 175, fear is followed closely behind at 150. Then comes anticipation, a positive emotion, but then is sadness and anger.

## Topic Modeling :
<img src="/images/topic_modeling.png" width="600"> 

Topic 1 : About PS5 release events for a game, Hitman, in January, while it is also being released on the Nintendo Switch.  
Topic 2 : Seems to be about the need for Sony (PS5) to assure fans and generate trust and to supply more PS5s to meet the demand.  
Topic 3 : About Amazon and it having PS5 in stock, possibly in the United Kingdom.   
Topic 4 : Customers are seeking for technical help.   
Topic 5 : Also about Amazon and PS5 stock but this time in the USA and the price on it.  
Topic 6 : Seems to be people asking for advice, possibly technical and asking or giving a link to follow in the tweet.  
