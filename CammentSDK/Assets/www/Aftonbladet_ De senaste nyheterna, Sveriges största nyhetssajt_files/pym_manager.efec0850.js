!function t(e,i,s){function n(r,o){if(!i[r]){if(!e[r]){var h="function"==typeof require&&require;if(!o&&h)return h(r,!0);if(a)return a(r,!0);var l=new Error("Cannot find module '"+r+"'");throw l.code="MODULE_NOT_FOUND",l}var d=i[r]={exports:{}};e[r][0].call(d.exports,function(t){var i=e[r][1][t];return n(i?i:t)},d,d.exports,t,e,i,s)}return i[r].exports}for(var a="function"==typeof require&&require,r=0;r<s.length;r++)n(s[r]);return n}({1:[function(t,e,i){"use strict";var s=t("./vendors/pym.v1.min"),n=new s.Child;document.addEventListener("DOMContentLoaded",function(){setTimeout(n.sendHeight,500)})},{"./vendors/pym.v1.min":2}],2:[function(t,e,i){"use strict";!function(t){"function"==typeof define&&define.amd?define(t):"undefined"!=typeof e&&e.exports?e.exports=t():window.pym=t.call(this)}(function(){var t="xPYMx",e={},i=function(t){var e=document.createEvent("Event");e.initEvent("pym:"+t,!0,!0),document.dispatchEvent(e)},s=function(t){var e=new RegExp("[\\?&]"+t.replace(/[\[]/,"\\[").replace(/[\]]/,"\\]")+"=([^&#]*)"),i=e.exec(location.search);return null===i?"":decodeURIComponent(i[1].replace(/\+/g," "))},n=function(t,e){if(("*"===e.xdomain||t.origin.match(new RegExp(e.xdomain+"$")))&&"string"==typeof t.data)return!0},a=function(e,i,s){var n=["pym",e,i,s];return n.join(t)},r=function(e){var i=["pym",e,"(\\S+)","(.*)"];return new RegExp("^"+i.join(t)+"$")},o=function(){for(var t=e.autoInitInstances.length,i=t-1;i>=0;i--){var s=e.autoInitInstances[i];s.el.getElementsByTagName("iframe").length&&s.el.getElementsByTagName("iframe")[0].contentWindow||e.autoInitInstances.splice(i,1)}};return e.autoInitInstances=[],e.autoInit=function(t){var s=document.querySelectorAll("[data-pym-src]:not([data-pym-auto-initialized])"),n=s.length;o();for(var a=0;a<n;++a){var r=s[a];r.setAttribute("data-pym-auto-initialized",""),""===r.id&&(r.id="pym-"+a+"-"+Math.random().toString(36).substr(2,5));var h=r.getAttribute("data-pym-src"),l={xdomain:"string",title:"string",name:"string",id:"string",sandbox:"string",allowfullscreen:"boolean",parenturlparam:"string",parenturlvalue:"string",optionalparams:"boolean"},d={};for(var g in l)if(null!==r.getAttribute("data-pym-"+g))switch(l[g]){case"boolean":d[g]=!("false"===r.getAttribute("data-pym-"+g));break;case"string":d[g]=r.getAttribute("data-pym-"+g);break;default:console.err("unrecognized attribute type")}var u=new e.Parent(r.id,h,d);e.autoInitInstances.push(u)}return t||i("pym-initialized"),e.autoInitInstances},e.Parent=function(t,e,i){this.id=t,this.url=e,this.el=document.getElementById(t),this.iframe=null,this.settings={xdomain:"*",optionalparams:!0,parenturlparam:"parentUrl",parenturlvalue:window.location.href},this.messageRegex=r(this.id),this.messageHandlers={},i=i||{},this._constructIframe=function(){var t=this.el.offsetWidth.toString();this.iframe=document.createElement("iframe");var e="",i=this.url.indexOf("#");for(i>-1&&(e=this.url.substring(i,this.url.length),this.url=this.url.substring(0,i)),this.url.indexOf("?")<0?this.url+="?":this.url+="&",this.iframe.src=this.url+"initialWidth="+t+"&childId="+this.id,this.settings.optionalparams&&(this.iframe.src+="&parentTitle="+encodeURIComponent(document.title),this.iframe.src+="&"+this.settings.parenturlparam+"="+encodeURIComponent(this.settings.parenturlvalue)),this.iframe.src+=e,this.iframe.setAttribute("width","100%"),this.iframe.setAttribute("scrolling","no"),this.iframe.setAttribute("marginheight","0"),this.iframe.setAttribute("frameborder","0"),this.settings.title&&this.iframe.setAttribute("title",this.settings.title),void 0!==this.settings.allowfullscreen&&this.settings.allowfullscreen!==!1&&this.iframe.setAttribute("allowfullscreen",""),void 0!==this.settings.sandbox&&"string"==typeof this.settings.sandbox&&this.iframe.setAttribute("sandbox",this.settings.sandbox),this.settings.id&&(document.getElementById(this.settings.id)||this.iframe.setAttribute("id",this.settings.id)),this.settings.name&&this.iframe.setAttribute("name",this.settings.name);this.el.firstChild;)this.el.removeChild(this.el.firstChild);this.el.appendChild(this.iframe),window.addEventListener("resize",this._onResize)},this._onResize=function(){this.sendWidth()}.bind(this),this._fire=function(t,e){if(t in this.messageHandlers)for(var i=0;i<this.messageHandlers[t].length;i++)this.messageHandlers[t][i].call(this,e)},this.remove=function(){window.removeEventListener("message",this._processMessage),window.removeEventListener("resize",this._onResize),this.el.removeChild(this.iframe),o()},this._processMessage=function(t){if(n(t,this.settings)&&"string"==typeof t.data){var e=t.data.match(this.messageRegex);if(!e||3!==e.length)return!1;var i=e[1],s=e[2];this._fire(i,s)}}.bind(this),this._onHeightMessage=function(t){var e=parseInt(t);this.iframe.setAttribute("height",e+"px")},this._onNavigateToMessage=function(t){document.location.href=t},this._onScrollToChildPosMessage=function(t){var e=document.getElementById(this.id).getBoundingClientRect().top+window.pageYOffset,i=e+parseInt(t);window.scrollTo(0,i)},this.onMessage=function(t,e){t in this.messageHandlers||(this.messageHandlers[t]=[]),this.messageHandlers[t].push(e)},this.sendMessage=function(t,e){this.el.getElementsByTagName("iframe").length&&(this.el.getElementsByTagName("iframe")[0].contentWindow?this.el.getElementsByTagName("iframe")[0].contentWindow.postMessage(a(this.id,t,e),"*"):this.remove())},this.sendWidth=function(){var t=this.el.offsetWidth.toString();this.sendMessage("width",t)};for(var s in i)this.settings[s]=i[s];return this.onMessage("height",this._onHeightMessage),this.onMessage("navigateTo",this._onNavigateToMessage),this.onMessage("scrollToChildPos",this._onScrollToChildPosMessage),window.addEventListener("message",this._processMessage,!1),this._constructIframe(),this},e.Child=function(e){this.parentWidth=null,this.id=null,this.parentTitle=null,this.parentUrl=null,this.settings={renderCallback:null,xdomain:"*",polling:0,parenturlparam:"parentUrl"},this.timerId=null,this.messageRegex=null,this.messageHandlers={},e=e||{},this.onMessage=function(t,e){t in this.messageHandlers||(this.messageHandlers[t]=[]),this.messageHandlers[t].push(e)},this._fire=function(t,e){if(t in this.messageHandlers)for(var i=0;i<this.messageHandlers[t].length;i++)this.messageHandlers[t][i].call(this,e)},this._processMessage=function(t){if(n(t,this.settings)&&"string"==typeof t.data){var e=t.data.match(this.messageRegex);if(e&&3===e.length){var i=e[1],s=e[2];this._fire(i,s)}}}.bind(this),this._onWidthMessage=function(t){var e=parseInt(t);e!==this.parentWidth&&(this.parentWidth=e,this.settings.renderCallback&&this.settings.renderCallback(e),this.sendHeight())},this.sendMessage=function(t,e){window.parent.postMessage(a(this.id,t,e),"*")},this.sendHeight=function(){var t=document.getElementsByTagName("body")[0].offsetHeight.toString();return this.sendMessage("height",t),t}.bind(this),this.scrollParentTo=function(t){this.sendMessage("navigateTo","#"+t)},this.navigateParentTo=function(t){this.sendMessage("navigateTo",t)},this.scrollParentToChildEl=function(t){var e=document.getElementById(t).getBoundingClientRect().top+window.pageYOffset;this.scrollParentToChildPos(e)},this.scrollParentToChildPos=function(t){this.sendMessage("scrollToChildPos",t.toString())};var r=function(t){var e,s=document.getElementsByTagName("html")[0],n=s.className;try{e=window.self!==window.top?"embedded":"not-embedded"}catch(t){e="embedded"}n.indexOf(e)<0&&(s.className=n?n+" "+e:e,t&&t(e),i("marked-embedded"))};this.remove=function(){window.removeEventListener("message",this._processMessage),this.timerId&&clearInterval(this.timerId)};for(var o in e)this.settings[o]=e[o];this.id=s("childId")||e.id,this.messageRegex=new RegExp("^pym"+t+this.id+t+"(\\S+)"+t+"(.*)$");var h=parseInt(s("initialWidth"));return this.parentUrl=s(this.settings.parenturlparam),this.parentTitle=s("parentTitle"),this.onMessage("width",this._onWidthMessage),window.addEventListener("message",this._processMessage,!1),this.settings.renderCallback&&this.settings.renderCallback(h),this.sendHeight(),this.settings.polling&&(this.timerId=window.setInterval(this.sendHeight,this.settings.polling)),r(e.onMarkedEmbeddedStatus),this},"undefined"!=typeof document&&e.autoInit(!0),e})},{}]},{},[1]);