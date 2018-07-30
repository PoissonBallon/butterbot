<h3 align="center">
<a href="https://github.com/NoRespect/ButterBot">
<img src="./Assets/roundIcon.png" width="200" />
<br />
<br />
</a>
ButterBot
</h3>

------

[![Swift 4.1](https://img.shields.io/badge/Language-Swift%204.1-orange.svg)](https://developer.apple.com/swift/)
[![Vapor 3](https://img.shields.io/badge/vapor-3-00B0FF.svg?logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzIiIGhlaWdodD0iMzIiIHZpZXdCb3g9IjAgMCAyIDIiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PGxpbmVhckdyYWRpZW50IHgxPSIwJSIgeTE9IjI0JSIgeDI9IjAlIiB5Mj0iOTYlIiBpZD0iYyI+PHN0b3Agc3RvcC1jb2xvcj0iIzQzQzRGQyIvPjxzdG9wIHN0b3AtY29sb3I9IiNERjQzRjYiIG9mZnNldD0iMTAwJSIvPjwvbGluZWFyR3JhZGllbnQ+PC9kZWZzPjxwYXRoIGZpbGw9InVybCgjYykiIGQ9Ik0xLDAgQzEsMCAxLjcsMC45IDEuNywxLjMgQzEuNywxLjcgMS40LDIgMSwyIEMwLjYsMiAwLjMsMS43IDAuMywxLjMgQzAuMywwLjkgMSwwIDEsMCBaIi8+PC9zdmc+
)](https://github.com/vapor/vapor)
[![Build Status](https://travis-ci.org/NoRespect/ButterBot.svg?branch=master)](https://travis-ci.org/NoRespect/ButterBot)
[![HitCount](http://hits.dwyl.com/NoRespect/ButterBot.svg)](http://hits.dwyl.com/NoRespect/ButterBot)
[![License](https://img.shields.io/badge/License-WTFPL-blue.svg)](http://www.wtfpl.net/)


Butterbot is a blazingly dumb bot written in Swift 4.1 with Vapor 3.

This project doesn't use IA / Machine learning / Neural Network, or *[random_hype_technology]* but just a fucking good old fashion parser.

**Butterbot talk only in french for now :confused:** :fr:

## Why ?

Coz I can,

## Installation

<a href="https://slack.com/oauth/authorize?scope=incoming-webhook,bot&client_id=18376735542.351461878310"><img alt="Add to Slack" height="40" width="139" src="https://platform.slack-edge.com/img/add_to_slack.png" srcset="https://platform.slack-edge.com/img/add_to_slack.png 1x, https://platform.slack-edge.com/img/add_to_slack@2x.png 2x" /></a>

# Functionalities

All the architecture is designed to add easily feature but the question is : Will I have the motivation to do it ?

## Karma

Add and remove points to create incredible war and bad mood on your slack.

#### Usage :

<table style="width:100%">
 <tr>
  <th>Command</th>
  <th>Usage</th>
  <th>Example</th>
 </tr>
 <tr>
  <td>Add Point</td>
  <td>Add point to a member or thing</td>
  <td>@poisson ++ <i>or</i> #thing ++</td>
 </tr>
 <tr>
  <td>Remove Point</td>
  <td>Remove point to a member or thing</td>
  <td>@poisson -- <i>or</i> #thing --</td>
 </tr>
 <tr>
  <td>Leaderboard</td>
  <td>Show top X member or thing</td>
  <td>@butterbot leaderboard <i>[optional_top]<i> </td>
 </tr>
</table>

#### Screenshot :

<img src="./Assets/screen_leaderboard.png" width="500" />

## AskMe

Butterbot answers any sentence with `Est-ce que`

#### Screenshot :

<img src="./Assets/screen_isit.png" width="300" />

## TalkTooMuch

< Coming Soon >

# Author

* PoissonBallon [@poissonballon](https://twitter.com/poissonballon)
* All NoRespect Team https://github.com/orgs/NoRespect/people

# License

Butterbot is available under the WTFPL *(Do What the Fuck You Want to Public License)* license.

Check the website for more information : http://www.wtfpl.net/
