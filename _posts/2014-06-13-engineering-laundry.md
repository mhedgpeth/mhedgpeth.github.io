---
id: 198
title: Engineering Laundry
date: 2014-06-13T08:00:54+00:00
author: Michael Hedgpeth
layout: post
guid: http://hedge-ops.com/?p=198
permalink: /engineering-laundry/
dsq_thread_id:
  - 2790122822
snap_MYURL:
  - 
snapEdIT:
  - 1
snapFB:
  - 's:218:"a:1:{i:0;a:8:{s:4:"doFB";s:1:"1";s:8:"postType";s:1:"A";s:10:"AttachPost";s:1:"2";s:10:"SNAPformat";s:16:"%TITLE% - %SURL%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";}}";'
snapLI:
  - 's:265:"a:1:{i:0;a:8:{s:4:"doLI";s:1:"1";s:10:"AttachPost";s:1:"1";s:10:"SNAPformat";s:41:"New post has been published on %SITENAME%";s:11:"SNAPformatT";s:18:"New Post - %TITLE%";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";s:9:"isAutoURL";s:1:"A";s:8:"urlToUse";s:0:"";}}";'
snapTW:
  - 's:146:"a:1:{i:0;a:5:{s:4:"doTW";s:1:"1";s:10:"SNAPformat";s:16:"%TITLE% - %SURL%";s:8:"attchImg";s:1:"1";s:9:"isAutoImg";s:1:"A";s:8:"imgToUse";s:0:"";}}";'
categories:
  - insights
tags:
  - batching
  - engineering
  - flow
  - laundry
  - lean
  - limiting wip
  - process
---
Before two weeks ago, <a title="Reclaimed House" href="http://reclaimed.house" target="_blank">my wife</a> had an intense hatred she only shared with close friends. This was something she avoided; she abhorred. Something that trapped her in a life of anger and despair.

Clothes. Worn and discarded. Washed. Dried. Put away. Repeat. Until death.

A couple of weeks ago, she asked me to reduce her workload by doing laundry. I wasn’t thrilled but I couldn't argue against helping her out with a job that I could do.

Once I got to thinking about it, here’s what really intrigued me: laundry is a simple system that can be optimized, or engineered, for maximum efficiencies. As an engineer, I really love maximizing efficiencies. So I decided to tackle this problem of laundry using principles I've learned as an engineer.<!--more-->

## Inherited **System**

The system I inherited went something like this, for our family of five:

  1. Each room on the second floor has a clothes hamper (all of our sleeping rooms are on the second floor). When cleaning the room, put the clothes in the clothes hamper.
  2. If you’re on the first floor, put the clothes in the laundry room which is on the first floor.
  3. Once a week, on no particular day, take all the clothes from the rooms and pile it in the laundry room.
  4. Sort the clothes into loads of whites, colors, towels.
  5. Wash and dry the clothes (this takes two days).
  6. When the clothes are dried, put the clothes that are to be hung up flat on top of the dryer. Put the clothes that are in dressers in a bag that hangs on the wall, one for each person. There is also a bag for kitchen towels and bathroom towels.
  7. At some point take all bags upstairs, and put the clothes away in dressers.
  8. At some point hang up the clothes.

This entire process would begin as it was ending. In other words, laundry ended up being a neverending mess of never-done-ness.

## Problems **with the System**

I looked at the system not as a household chore but as a system that I could maximize using principles I use at work. So looking at it that way, what were the problems with this system?

  * **Excessive Batching.** Everything was piled up and done at once, and there was no flow. When there is so much work in progress, you can’t optimize the system because there are too many variables in it. It’s like trying to cook Thanksgiving Dinner&#8230;all at once. There has to be a clear process in place and simplicity at every step for any hope of true optimization.
  * **Excessive Sorting.** Laundry was sorted at least two times within a large set. There was a separation of _all the laundry_ into loads, and another separation of _all the laundry_ by who owned the laundry. This was especially difficult with the kids, whose sizes are remarkably similar and ever-changing, even though they insist it’s totally obvious that the shirt belongs to one or the other.
  * **Lack of Ownership.** My wife was doing all the work. None of us wanted to do the job. So we were leaving valuable contributions from me and my sons on the table, which led to&#8230;
  * **Despair from Lack of Closure.** The system didn’t give you a sense of being “done”. In software terms there was no “release”. It was just always going.

## New System

I did some internet searching and [came across an article](http://lifeasmom.com/2013/04/kids-can-do-laundry.html) that was extremely close to what I have implemented. It addresses all of the problems stated above. Here’s the system:

  1. Every person in the house gets their own laundry basket except for parents who share theirs. Every person is responsible for putting their own clothes into _only_ their own basket.
  2. There is a basket downstairs that towels and linens go into.
  3. Every basket is done by its owner on a particular day of the week. Someone helps too if that's needed. Our schedule is:

<div class="table-responsive">
  <table  style="width:100%; "  class="easy-table easy-table-default " border="0">
    <tr>
      <th >
        Day
      </th>
      
      <th >
        Basket
      </th>
      
      <th >
        Owner
      </th>
      
      <th >
        Helper
      </th>
    </tr>
    
    <tr>
      <td >
        Monday
      </td>
      
      <td >
        Parents
      </td>
      
      <td >
        Mom
      </td>
      
      <td >
        Dad
      </td>
    </tr>
    
    <tr>
      <td >
        Tuesday
      </td>
      
      <td >
        Oldest
      </td>
      
      <td >
        Oldest
      </td>
      
      <td >
        Dad
      </td>
    </tr>
    
    <tr>
      <td >
        Wednesday
      </td>
      
      <td >
        Towels
      </td>
      
      <td >
        Dad
      </td>
      
      <td >
        Mom
      </td>
    </tr>
    
    <tr>
      <td >
        Thursday
      </td>
      
      <td >
        Middle Child
      </td>
      
      <td >
        Middle Child
      </td>
      
      <td >
        Dad
      </td>
    </tr>
    
    <tr>
      <td >
        Friday
      </td>
      
      <td >
        Youngest Child
      </td>
      
      <td >
        Dad
      </td>
      
      <td >
        Youngest Child
      </td>
    </tr>
  </table>
</div>

## Benefits of the New System

We’ve done this system for a week now, and wow has it made a difference. Here’s why:

  * We’ve broken the whole system down into smaller, manageable chunks. That way there is a sense of progress, completion, and lack of despair. Since the laundry room is clean (other than a basket with towels), it is a place where you can create an outcome relatively quickly and get out. You’re done. There’s not a big scary laundry monster in there to kill you.
  * Sorting has been drastically minimized. Now when we wash the youngest child’s clothes, it’s extremely clear whose clothes those are when they come out of the dryer. This knocks off the total time we spend on it.
  * Everyone owns laundry. It’s not something that only Mom does. And she gets to do the part that is most important to her (her own clothes), so we win by me not accidentally shrinking her brand new sweater.

The problem that one might have with this system is that you are doing laundry _every day_. But a different person is in charge of it, and it’s a mangable amount. It seems to be working out well for us so far.

The great thing I found through this process is how well management principles relate to so many other areas of life. That’s one of the things I want to explore in the future: taking wisdom from one area of life and applying it elsewhere.

_Do these principles apply to another area of your life?_

_ _