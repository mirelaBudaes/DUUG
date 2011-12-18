<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxml="urn:schemas-microsoft-com:xslt"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:umbraco.library="urn:umbraco.library"
  xmlns:PS.XSLTsearch="urn:PS.XSLTsearch"
  exclude-result-prefixes="msxml umbraco.library PS.XSLTsearch">

  <xsl:output method="xml" omit-xml-declaration="yes" />

  <!-- 
  ======================================================================
  XSLTsearch.xslt
  ======================================================================
  Copyright 2006-2010 Percipient Studios. All rights reserved.
  MIT License (http://www.opensource.org/licenses/mit-license.php)

  Version 3.0 - For umbraco 4.5+ and new XML schema
                Adds multi-lingual dictionary support (defaults to EN-US)
                Adds medium trust support (C# helper functions now in /app_code/XSLTsearch.cs)
                Numerous bug fixes
  
  www.percipientstudios.com
  ====================================================================== 
  -->

  <xsl:param name="currentPage"/>

  <xsl:variable name="startTime" select="PS.XSLTsearch:getTime()"/>
  <xsl:variable name="currentID" select="$currentPage/@id"/>
  <xsl:variable name="XSLTsearchVersion" select="'3.0'"/>

  <!-- DICTIONARY parameters for localization. Use default (English) text if dictionary item does not exist or has no value -->
  <xsl:variable name="dictionaryButton-Search" select="PS.XSLTsearch:getDictionaryParameter(string(umbraco.library:GetDictionaryItem('[XSLTsearch]Button-Search')), 'Search')"/>
  <xsl:variable name="dictionaryDescription-Context" select="PS.XSLTsearch:getDictionaryParameter(string(umbraco.library:GetDictionaryItem('[XSLTsearch]Description-Context')), 'Context')"/>
  <xsl:variable name="dictionaryDescription-ContextUnavailable" select="PS.XSLTsearch:getDictionaryParameter(string(umbraco.library:GetDictionaryItem('[XSLTsearch]Description-ContextUnavailable')), 'unavailable')"/>
  <xsl:variable name="dictionaryHeading-SearchResults" select="PS.XSLTsearch:getDictionaryParameter(string(umbraco.library:GetDictionaryItem('[XSLTsearch]Heading-SearchResults')), 'Search Results')"/>
  <xsl:variable name="dictionaryNavigation-Next" select="PS.XSLTsearch:getDictionaryParameter(string(umbraco.library:GetDictionaryItem('[XSLTsearch]Navigation-Next')), 'Next')"/>
  <xsl:variable name="dictionaryNavigation-Previous" select="PS.XSLTsearch:getDictionaryParameter(string(umbraco.library:GetDictionaryItem('[XSLTsearch]Navigation-Previous')), 'Previous')"/>
  <xsl:variable name="dictionaryPageRange-ShowingResults" select="PS.XSLTsearch:getDictionaryParameter(string(umbraco.library:GetDictionaryItem('[XSLTsearch]PageRange-ShowingResults')), 'Showing results')"/>
  <xsl:variable name="dictionaryPageRange-To" select="PS.XSLTsearch:getDictionaryParameter(string(umbraco.library:GetDictionaryItem('[XSLTsearch]PageRange-To')), 'to')"/>
  <xsl:variable name="dictionaryScore-Score" select="PS.XSLTsearch:getDictionaryParameter(string(umbraco.library:GetDictionaryItem('[XSLTsearch]Score-Score')), 'score')"/>
  <xsl:variable name="dictionaryStats-PagesIn" select="PS.XSLTsearch:getDictionaryParameter(string(umbraco.library:GetDictionaryItem('[XSLTsearch]Stats-PagesIn')), 'pages in')"/>
  <xsl:variable name="dictionaryStats-Searched" select="PS.XSLTsearch:getDictionaryParameter(string(umbraco.library:GetDictionaryItem('[XSLTsearch]Stats-Searched')), 'Searched')"/>
  <xsl:variable name="dictionaryStats-Seconds" select="PS.XSLTsearch:getDictionaryParameter(string(umbraco.library:GetDictionaryItem('[XSLTsearch]Stats-Seconds')), 'seconds')"/>
  <xsl:variable name="dictionarySummary-Matches" select="PS.XSLTsearch:getDictionaryParameter(string(umbraco.library:GetDictionaryItem('[XSLTsearch]Summary-Matches')), 'matches')"/>
  <xsl:variable name="dictionarySummary-NoMatchesWereFoundFor" select="PS.XSLTsearch:getDictionaryParameter(string(umbraco.library:GetDictionaryItem('[XSLTsearch]Summary-NoMatchesWereFoundFor')), 'No matches were found for')"/>
  <xsl:variable name="dictionarySummary-Page" select="PS.XSLTsearch:getDictionaryParameter(string(umbraco.library:GetDictionaryItem('[XSLTsearch]Summary-Page')), 'page')"/>
  <xsl:variable name="dictionarySummary-Pages" select="PS.XSLTsearch:getDictionaryParameter(string(umbraco.library:GetDictionaryItem('[XSLTsearch]Summary-Pages')), 'pages')"/>
  <xsl:variable name="dictionarySummary-YourSearchFor" select="PS.XSLTsearch:getDictionaryParameter(string(umbraco.library:GetDictionaryItem('[XSLTsearch]Summary-YourSearchFor')), 'Your search for')"/>

  <!-- MACRO parameters get default values if not passed in from the macro -->
  <xsl:variable name="source" select="string(PS.XSLTsearch:getParameter(string(/macro/source), '-1'))"/>
  <xsl:variable name="resultsPerPage" select="string(PS.XSLTsearch:getParameter(string(/macro/resultsPerPage), '5'))"/>
  <xsl:variable name="previewChars" select="string(PS.XSLTsearch:getParameter(string(/macro/previewChars), '255'))"/>
  <xsl:variable name="searchBoxLocation" select="PS.XSLTsearch:uppercase(PS.XSLTsearch:getParameter(string(/macro/searchBoxLocation), 'bottom'))"/>
  <!-- valid choices are: 'bottom' or 'top' or 'both' or 'none' -->
  <xsl:variable name="previewType" select="PS.XSLTsearch:uppercase(PS.XSLTsearch:getParameter(string(/macro/previewType), 'beginning'))"/>
  <!-- valid choices are: 'beginning' and 'context' -->
  <xsl:variable name="showPageRange" select="PS.XSLTsearch:uppercase(PS.XSLTsearch:getParameter(string(/macro/showPageRange), '0'))"/>
  <xsl:variable name="showOrdinals" select="PS.XSLTsearch:uppercase(PS.XSLTsearch:getParameter(string(/macro/showOrdinals), '0'))"/>
  <xsl:variable name="showScores" select="PS.XSLTsearch:uppercase(PS.XSLTsearch:getParameter(string(/macro/showScores), '0'))"/>
  <xsl:variable name="showStats" select="PS.XSLTsearch:uppercase(PS.XSLTsearch:getParameter(string(/macro/showStats), '0'))"/>
  <xsl:variable name="showDebug" select="PS.XSLTsearch:uppercase(PS.XSLTsearch:getParameter(string(umbraco.library:RequestQueryString('umbDebugShowTrace')), '0'))"/>

  <!-- which umbraco fields to search -->
  <!-- Note: Comma-separated list of fields. The order of the search fields affects the search score and
    order of the search results! Place the more important fields first, with bodyText last. 
    The reason is that if a search term appears in the page's title, there is a greater likelihood 
    that page discusses the search term at length, than it simply being mentioned in the bodyText in passing. 
  -->
  <xsl:variable name="searchFields" select="PS.XSLTsearch:getListParameter(string(/macro/searchFields), '@nodeName,metaKeywords,metaDescription,bodyText')"/>

  <!-- which umbraco field to display for a found entry -->
  <!-- Note: Comma-separated list of fields. The order of the preview fields is from most preferred 
    to least preferred. Put the most appropriate fields first (typically, bodyText).
    Note: ONLY works for properties, not attributes  
  -->
  <xsl:variable name="previewFields" select="PS.XSLTsearch:getListParameter(string(/macro/previewFields), 'bodyText,metaDescription')"/>

  <!-- the search term to look for -->
  <xsl:variable name="search">
    <xsl:choose>
      <!-- form field value, if present -->
      <xsl:when test="string(umbraco.library:RequestForm('search')) != ''">
        <xsl:value-of select="PS.XSLTsearch:escapeString(string(umbraco.library:RequestForm('search')))" />
      </xsl:when>
      <!-- querystring value, if present -->
      <xsl:when test="string(umbraco.library:RequestQueryString('search')) != ''">
        <xsl:value-of select="PS.XSLTsearch:escapeString(string(umbraco.library:RequestQueryString('search')))" />
      </xsl:when>
      <!-- no value -->
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="unescapedSearch" select="PS.XSLTsearch:unescapeString($search)"/>

  <!-- We have to calculate matching nodes before we can finish calculating the rest of the variables/parameters... -->
  <!-- uppercase the search string for case-insensitive searching -->
  <xsl:variable name="searchUpper" select="PS.XSLTsearch:uppercase(string($search))"/>


  <!-- ============================================================= -->


  <xsl:template match="/">
    <!-- determine which nodeset to search through, based on the value (or absence) of the SOURCE parameter in the macro -->
    <xsl:choose>
      <!-- short-circuit the whole searching if no search-text were passed in -->
      <xsl:when test="$search = ''">
        <!-- using NO nodes; only calling the template for the form -->
        <xsl:call-template name="search">
          <xsl:with-param name="items" select="./node[1=2]"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="number($source)= -1 or number($source)= 0">
        <!-- using ALL nodes -->
        <xsl:call-template name="search">
          <xsl:with-param name="items" select="umbraco.library:GetXmlAll()/*"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="number($source)=$currentID">
        <!-- using only nodes within the search page's family tree, from top to bottom -->
        <xsl:call-template name="search">
          <xsl:with-param name="items" select="$currentPage/ancestor-or-self::* [@isDoc and @level = 1]"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- search only within the SOURCE node specified in the macro and all of its children -->
        <xsl:call-template name="search">
          <xsl:with-param name="items" select="./descendant-or-self::*[@isDoc]"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- ============================================================= -->


  <xsl:template name="search">
    <!-- Perform the search on the appropriate nodeset and display the output -->
    <xsl:param name="items"/>

    <!-- reduce the number of nodes for applying all the functions in the next step -->
    <xsl:variable name="possibleNodes" select="$items/descendant-or-self::*[
                             @isDoc
                             and string(umbracoNaviHide) != '1'
                             and count(attribute::id)=1 
                             and (umbraco.library:IsProtected(@id, @path) = false()
                              or umbraco.library:HasAccess(@id, @path) = true())
                           ]"/>

    <!-- generate a string of a semicolon-delimited list of all @id's of the matching nodes -->
    <xsl:variable name="matchedNodesIdList">
      <xsl:call-template name="booleanAndMatchedNodes">
        <xsl:with-param name="yetPossibleNodes" select="$possibleNodes"/>
        <xsl:with-param name="searchTermList" select="concat($searchUpper, ' ')"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- get the actual matching nodes as a nodeset -->
    <xsl:variable name="matchedNodes" select="$possibleNodes[contains($matchedNodesIdList, concat(';', concat(@id, ';')))]" />

    <!-- the current page -->
    <xsl:variable name="page">
      <xsl:choose>
        <!-- first page -->
        <xsl:when test="number(umbraco.library:RequestQueryString('page')) &lt;=1 
            or string(umbraco.library:RequestQueryString('page')) = '' 
            or string(number(umbraco.library:RequestQueryString('page'))) = 'NaN'
            or (
              string(umbraco.library:RequestForm('search')) != ''
              and string(umbraco.library:RequestForm('search')) != string(umbraco.library:RequestQueryString('search'))
            )
        ">
          <xsl:text>1</xsl:text>
        </xsl:when>
        <!-- last page -->
        <xsl:when test="number(umbraco.library:RequestQueryString('page')) &gt; count($matchedNodes) div $resultsPerPage">
          <xsl:value-of select="ceiling(count($matchedNodes) div $resultsPerPage)"/>
        </xsl:when>
        <!-- the value specified in the querystring -->
        <xsl:otherwise>
          <xsl:value-of select="number(umbraco.library:RequestQueryString('page'))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- calculate a few handy variables now, for easy access later -->
    <xsl:variable name="startMatch" select="($page - 1) * $resultsPerPage + 1"/>
    <xsl:variable name="endMatch">
      <xsl:choose>
        <!-- all the rest (on the last page) -->
        <xsl:when test="($page * $resultsPerPage) &gt; count($matchedNodes)">
          <xsl:value-of select="count($matchedNodes)"/>
        </xsl:when>
        <!-- only the appropriate number for this page -->
        <xsl:otherwise>
          <xsl:value-of select="$page * $resultsPerPage"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- display results header information to the screen, if a search has been run; otherwise just show the search form -->
    <div id="xsltsearch">
      <xsl:if test="$unescapedSearch !=''">
        <!-- most pages have a search header specified in the template. If you wish XSLTsearch to display its own header, uncomment the <h2> ... </h2> lines below -->
        <!--
        <h2>
          <xsl:value-of select="$dictionaryHeading-SearchResults"/>
        </h2>
        --> 

        <!-- display search box at the top of the page (the search box is always present even if no search was attempted) -->
        <xsl:if test="$searchBoxLocation='TOP' or $searchBoxLocation='BOTH'">
          <div class="xsltsearch_form">
            <input name="search" type="text" class="input">
              <xsl:attribute name="value">
                <xsl:value-of select="$unescapedSearch"/>
              </xsl:attribute>
            </input>
            <xsl:text>&nbsp;</xsl:text>
            <input type="submit" class="submit">
              <xsl:attribute name="value">
                <xsl:value-of select="$dictionaryButton-Search"/>
              </xsl:attribute>
            </input>
          </div>
        </xsl:if>

        <p id="xsltsearch_summary">
          <xsl:choose>
            <xsl:when test="count($matchedNodes) = 0">
              <xsl:value-of select="$dictionarySummary-NoMatchesWereFoundFor"/>
              <xsl:text> </xsl:text>
              <strong>
                <xsl:value-of select="$unescapedSearch"/>
              </strong>
            </xsl:when>
            <xsl:when test="count($matchedNodes) = 1">
              <xsl:value-of select="$dictionarySummary-YourSearchFor"/>
              <xsl:text> </xsl:text>
              <strong>
                <xsl:value-of select="$unescapedSearch"/>
              </strong>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$dictionarySummary-Matches"/>
              <xsl:text> </xsl:text>
              <strong>1</strong>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$dictionarySummary-Page"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$dictionarySummary-YourSearchFor"/>
              <xsl:text> </xsl:text>
              <strong>
                <xsl:value-of select="$unescapedSearch"/>
              </strong>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$dictionarySummary-Matches"/>
              <xsl:text> </xsl:text>
              <strong>
                <xsl:value-of select="count($matchedNodes)"/>
              </strong>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$dictionarySummary-Pages"/>
            </xsl:otherwise>
          </xsl:choose>

          <!-- show the page number range. Useful if you don't show the ordinal for the result -->
          <xsl:if test="$showPageRange != '0'">
            <xsl:if test="count($matchedNodes) &gt; 0">
              <br />
              <span id="xsltsearch_pagerange">
                <xsl:value-of select="$dictionaryPageRange-ShowingResults"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$startMatch"/>
                <xsl:if test="$startMatch != $endMatch">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$dictionaryPageRange-To"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$endMatch"/>
                </xsl:if>
              </span>
            </xsl:if>
          </xsl:if>
        </p>

        <!-- Now we need to sort the pages by score/relevance before sending them to the screen. 
           We'll cycle through matched nodes once to save their pageScore in a variable -->
        <xsl:variable name="pageScoreList">
          <xsl:text>;</xsl:text>
          <xsl:for-each select="$matchedNodes">
            <!-- unique id for this node -->
            <xsl:value-of select="generate-id(.)"/>
            <xsl:text>=</xsl:text>
            <!-- weighted score for the matches -->
            <xsl:call-template name="pageScore">
              <xsl:with-param name="item" select="."/>
            </xsl:call-template>
            <xsl:text>;</xsl:text>
          </xsl:for-each>
        </xsl:variable>

        <!-- display search results to the screen -->
        <div id="xsltsearch_results">
          <xsl:if test="count($matchedNodes) = 0">
            <xsl:text disable-output-escaping="yes"> </xsl:text>
          </xsl:if>

          <xsl:for-each select="$matchedNodes">
            <!-- sort on the page score of the node, within ALL the nodes to return (the sorting must happen before choosing the nodes for this page) -->
            <xsl:sort select="substring-before(substring-after($pageScoreList, concat(';',generate-id(.),'=')),';')" data-type="number" order="descending"/>

            <!-- only the nodes for this page -->
            <xsl:if test="position() &gt;= $startMatch and position() &lt;= $endMatch">

              <div class="xsltsearch_result">
                <p class="xsltsearch_result_title">
                  <!-- show the ordinal number for this result -->
                  <xsl:if test="$showOrdinals != '0'">
                    <span class="xsltsearch_ordinal">
                      <xsl:value-of select="position()"/>
                      <xsl:text>.&nbsp;</xsl:text>
                    </span>
                  </xsl:if>

                  <!-- page name and url -->
                  <a href="{umbraco.library:NiceUrl(@id)}" class="xsltsearch_title">
                    <xsl:value-of select="@nodeName"/>
                  </a>

                  <!-- show the pageScore/relevance rating -->
                  <xsl:if test="$showScores != '0'">
                    <span class="xsltsearch_score">
                      <xsl:text> (</xsl:text>
                      <xsl:value-of select="$dictionaryScore-Score"/>
                      <xsl:text>: </xsl:text>
                      <xsl:value-of select="substring-before(substring-after($pageScoreList, concat(';',generate-id(.),'=')),';')"/>
                      <xsl:text>)</xsl:text>
                    </span>
                  </xsl:if>
                </p>

                <xsl:variable name="displayField">
                  <xsl:call-template name="displayFieldText">
                    <xsl:with-param name="item" select="."/>
                    <xsl:with-param name="fieldList" select="$previewFields"/>
                  </xsl:call-template>
                </xsl:variable>

                <!-- contents of search result -->
                <xsl:variable name="strippedHTML" select="umbraco.library:StripHtml($displayField)"/>

                <xsl:variable name="escapedData">
                  <xsl:choose>
                    <!-- display content of the search result, if available -->
                    <xsl:when test="string($strippedHTML) != ''">
                      <xsl:value-of select="$strippedHTML"/>
                    </xsl:when>
                  </xsl:choose>
                </xsl:variable>

                <!-- prepare for highlighting the search term within the search results by surrounding it with 'strong' tags -->
                <xsl:variable name="before">&lt;strong&gt;</xsl:variable>
                <xsl:variable name="after">&lt;/strong&gt;</xsl:variable>

                <!-- display a portion of the page's text -->
                <!-- display first words of the text -->
                <xsl:if test="$previewType = 'BEGINNING' and string-length($escapedData &gt; 0)">
                  <p class="xsltsearch_result_description">
                    <span class="xsltsearch_description">
                      <xsl:value-of select="PS.XSLTsearch:surround(PS.XSLTsearch:escapingIntelligentSubstring($escapedData, 0, $previewChars), $search, $before, $after)" disable-output-escaping="yes"/>
                      <!-- add an elipsis if there is more text than we are showing on the search results page -->
                      <xsl:if test="string-length($escapedData) &gt; $previewChars">...</xsl:if>
                    </span>
                  </p>
                </xsl:if>

                <!-- or, display the actual place(s) where the search term was found and highlight them in context
                     providing a few words on either side of the search term. -->
                <xsl:if test="$previewType = 'CONTEXT' and string-length($escapedData &gt; 0)">
                  <p class="xsltsearch_result_description">
                    <span class="xsltsearch_description">
                      <i>
                        <xsl:value-of select="$dictionaryDescription-Context"/>
                        <xsl:text>: </xsl:text>
                      </i>
                      <xsl:variable name="context" select="PS.XSLTsearch:contextOfFind(string($escapedData), $search, 5, 5, $previewChars)"/>
                      <xsl:choose>
                        <xsl:when test="string($context) != ''">
                          <xsl:value-of select="PS.XSLTsearch:surround($context, $search, $before, $after)" disable-output-escaping="yes"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <i>
                            <xsl:value-of select="$dictionaryDescription-ContextUnavailable"/>
                          </i>
                        </xsl:otherwise>
                      </xsl:choose>
                    </span>
                  </p>
                </xsl:if>

                <!-- OPTIONAL: include any additional information regarding the search result you want to display, such as createDate, updateDate, author, etc. -->

              </div>
            </xsl:if>

          </xsl:for-each>
        </div>

        <!-- display paging navigation links, if needed -->
        <xsl:if test="$resultsPerPage &lt; count($matchedNodes)">
          <xsl:call-template name="searchNavigation">
            <xsl:with-param name="page" select="$page"/>
            <xsl:with-param name="matchedNodes" select="$matchedNodes"/>
          </xsl:call-template>
        </xsl:if>

      </xsl:if>

      <!-- display search box at the bottom of the page (the search box is always present even if no search was attempted) -->
      <xsl:if test="$searchBoxLocation='BOTTOM' or $searchBoxLocation='BOTH' or ($searchBoxLocation!='NONE' and $unescapedSearch ='')">
        <div class="xsltsearch_form">
          <input name="search" type="text" class="input">
            <xsl:attribute name="value">
              <xsl:value-of select="$unescapedSearch"/>
            </xsl:attribute>
          </input>
          <xsl:text>&nbsp;</xsl:text>
          <input type="submit" class="submit">
            <xsl:attribute name="value">
              <xsl:value-of select="$dictionaryButton-Search"/>
            </xsl:attribute>
          </input>
        </div>
      </xsl:if>

      <!-- display search execution time and stats -->
      <xsl:if test="$showStats != '0'">
        <xsl:if test="$search !=''">
          <p id="xsltsearch_stats">
            <xsl:value-of select="$dictionaryStats-Searched"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="count($possibleNodes)"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$dictionaryStats-PagesIn"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="round(PS.XSLTsearch:getTimeSpan($startTime, PS.XSLTsearch:getTime())) div 1000"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$dictionaryStats-Seconds"/>
          </p>
        </xsl:if>
      </xsl:if>

      <!-- display XSLTsearch version information if in debug mode (that is, if the querystring contains umbDebugShowTrace=true) -->
      <xsl:if test="$showDebug != '0'">
        <p id="xsltsearch_debug">
          <xsl:text>XSLTsearch version </xsl:text>
          <xsl:value-of select="$XSLTsearchVersion"/>
        </p>
      </xsl:if>

      <!-- don't let a collapsed div tag break the page layout -->
      <xsl:if test="$unescapedSearch='' and $searchBoxLocation='NONE'">
        <xsl:text>&nbsp;</xsl:text>
      </xsl:if>
    </div>
  </xsl:template>


  <!-- ============================================================= -->


  <xsl:template name="searchNavigation">
    <!-- navigation template (Note: we're just using hrefs with querystrings) -->
    <xsl:param name="page"/>
    <xsl:param name="matchedNodes"/>

    <p id="xsltsearch_navigation">
      <!-- previous page -->
      <a id="previous">
        <xsl:choose>
          <xsl:when test="$page &lt;= 1">
            <xsl:attribute name="class">disabled</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="href">
              <xsl:text>?search=</xsl:text>
              <xsl:value-of select="$search"/>
              <xsl:text>&amp;page=</xsl:text>
              <xsl:value-of select="$page - 1"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&lt; </xsl:text>
        <xsl:value-of select="$dictionaryNavigation-Previous"/>
      </a>
      <xsl:text>&nbsp;&nbsp;</xsl:text>

      <!-- each paged set of results is listed, with a link to that page set -->
      <xsl:call-template name="pageNumbers">
        <xsl:with-param name="pageIndex" select="1"/>
        <xsl:with-param name="page" select="$page"/>
        <xsl:with-param name="matchedNodes" select="$matchedNodes"/>
      </xsl:call-template>

      <!-- next page -->
      <xsl:text>&nbsp;</xsl:text>
      <a id="next">
        <xsl:choose>
          <xsl:when test="$page * $resultsPerPage &gt;= count($matchedNodes)">
            <xsl:attribute name="class">disabled</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="href">
              <xsl:text>?search=</xsl:text>
              <xsl:value-of select="$search"/>
              <xsl:text>&amp;page=</xsl:text>
              <xsl:value-of select="$page + 1"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$dictionaryNavigation-Next"/>
        <xsl:text> &gt;</xsl:text>
      </a>
    </p>
  </xsl:template>


  <!-- ============================================================= -->


  <xsl:template name="pageNumbers">
    <!-- paged results template -->
    <xsl:param name="page"/>
    <xsl:param name="pageIndex"/>
    <xsl:param name="matchedNodes"/>

    <xsl:variable name="distanceFromCurrent" select="$pageIndex - $page"/>

    <xsl:choose>
      <xsl:when test="$pageIndex = $page">
        <!-- current paged set -->
        <strong>
          <xsl:value-of select="$pageIndex"/>
        </strong>
        <xsl:text>&nbsp;</xsl:text>
      </xsl:when>

      <!-- show a maximum of nine paged sets on either side of the current paged set; just like Google does it -->
      <xsl:when test="($distanceFromCurrent &gt; -10 and $distanceFromCurrent &lt; 10)">
        <a>
          <xsl:attribute name="href">
            <xsl:text>?search=</xsl:text>
            <xsl:value-of select="$search"/>
            <xsl:text>&amp;page=</xsl:text>
            <xsl:value-of select="$pageIndex"/>
          </xsl:attribute>
          <xsl:value-of select="$pageIndex"/>
        </a>
        <xsl:text>&nbsp;</xsl:text>
      </xsl:when>
    </xsl:choose>

    <!-- recursively call the template for all the paged sets -->
    <xsl:if test="$pageIndex * $resultsPerPage &lt; count($matchedNodes)">
      <xsl:call-template name="pageNumbers">
        <xsl:with-param name="pageIndex" select="$pageIndex + 1"/>
        <xsl:with-param name="page" select="$page"/>
        <xsl:with-param name="matchedNodes" select="$matchedNodes"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


  <!-- ============================================================= -->


  <xsl:template name="pageScore">
    <xsl:param name="item"/>

    <!-- sum up scores for each of the attributes -->
    <xsl:variable name="scoreA">
      <xsl:call-template name="scoreAttributes">
        <xsl:with-param name="item" select="$item"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- sum up scores for each of the data nodes -->
    <xsl:variable name="scoreD">
      <xsl:call-template name="scoreDataNodes">
        <xsl:with-param name="item" select="$item[@isDoc]/*[not(@isDoc) and contains($searchFields, concat(',',name(),','))]"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:value-of select="number($scoreA) + number($scoreD)"/>
  </xsl:template>


  <!-- ============================================================= -->


  <xsl:template name="scoreAttributes">
    <xsl:param name="item"/>
    <xsl:param name="index" select="1"/>
    <xsl:param name="score" select="0"/>

    <!-- name of the attribute on which we're searching -->
    <xsl:variable name="attributeName" select="name($item/attribute::*[position()=$index])"/>

    <xsl:variable name="weighting">
      <xsl:if test="contains($searchFields, concat(',@',$attributeName,','))">
        <xsl:value-of select="PS.XSLTsearch:power(2, number(PS.XSLTsearch:hitCount(substring-after($searchFields,$attributeName), ','))-1)"/>
      </xsl:if>
    </xsl:variable>

    <!-- calculate the final, cumulative, weighted score for this field -->
    <xsl:variable name="thisScore">
      <xsl:choose>
        <xsl:when test="contains($searchFields, concat(',@',$attributeName,','))">
          <!-- only calculate when this is a field actually being searched -->
          <xsl:call-template name="scoreForBooleanSearch">
            <xsl:with-param name="weighting" select="$weighting"/>
            <xsl:with-param name="toSearch" select="umbraco.library:StripHtml(string($item/attribute::*[name()=$attributeName]))"/>
            <xsl:with-param name="searchTermList" select="concat($search, ' ')"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="count(./attribute::*)=$index">
        <!-- all done; print out total weight score -->
        <xsl:value-of select="$score + $thisScore"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- continue recursion for other fields -->
        <xsl:call-template name="scoreAttributes">
          <xsl:with-param name="item" select="$item"/>
          <xsl:with-param name="index" select="$index + 1"/>
          <xsl:with-param name="score" select="$score + $thisScore"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- ============================================================= -->


  <xsl:template name="scoreForBooleanSearch">
    <xsl:param name="weighting" select="1"/>
    <xsl:param name="toSearch"/>
    <xsl:param name="searchTermList"/>
    <xsl:param name="currentHitCount" select="0"/>

    <!-- next search term -->
    <xsl:variable name="searchTerm">
      <xsl:value-of select="PS.XSLTsearch:getFirstElement($searchTermList, ' ')"/>
    </xsl:variable>

    <!-- remaining search terms -->
    <xsl:variable name="remainingSearchTermList">
      <xsl:value-of select="PS.XSLTsearch:removeFirstElement($searchTermList, ' ')"/>
    </xsl:variable>

    <!-- hit count for this search term -->
    <xsl:variable name="thisHitCount">
      <xsl:value-of select="PS.XSLTsearch:hitCount($toSearch, string($searchTerm))"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="string-length($remainingSearchTermList) &gt; 1">
        <!-- continue to search the rest of the terms -->
        <xsl:call-template name="scoreForBooleanSearch">
          <xsl:with-param name="weighting" select="$weighting"/>
          <xsl:with-param name="toSearch" select="$toSearch"/>
          <xsl:with-param name="searchTermList" select="$remainingSearchTermList"/>
          <xsl:with-param name="currentHitCount" select="$currentHitCount + $thisHitCount"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <!-- finished searching: return the total hit count * weighting -->
        <xsl:value-of select="number($currentHitCount + $thisHitCount) * $weighting"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- ============================================================= -->


  <xsl:template name="scoreDataNodes">
    <xsl:param name="item"/>
    <xsl:param name="score" select="0"/>

    <!-- the weighting to apply to hits in this search field -->
    <xsl:variable name="weighting" select="PS.XSLTsearch:power(2, number(PS.XSLTsearch:hitCount(substring-after($searchFields,string(name($item))), ','))-1)"/>

    <!-- calculate the final, cumulative, weighted score for this field -->
    <xsl:variable name="thisScore">
      <xsl:choose>
        <xsl:when test="contains($searchFields, concat(',',name($item),','))">
          <!-- only calculate when this is a field actually being searched -->
          <xsl:call-template name="scoreForBooleanSearch">
            <xsl:with-param name="weighting" select="$weighting"/>
            <xsl:with-param name="toSearch" select="umbraco.library:StripHtml(string($item))"/>
            <xsl:with-param name="searchTermList" select="concat($search, ' ')"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- remaining data nodes whose hitCounts we need to tally; for recursion use -->
    <xsl:variable name="remaining" select="$item/following-sibling::*[not(@isDoc) and contains($searchFields, concat(',',name(),','))]"/>
    <xsl:choose>
      <xsl:when test="count($remaining) = 0">
        <!-- all done; return the final score -->
        <xsl:value-of select="number($thisScore) + number($score)"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- keep summing the hitCounts for all the fields for this page by calling the pageScore template recursively -->
        <xsl:call-template name="scoreDataNodes">
          <xsl:with-param name="item" select="$remaining[position()=1]"/>
          <xsl:with-param name="score" select="number($thisScore) + number($score)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- ============================================================= -->


  <xsl:template name="displayFieldText">
    <xsl:param name="item"/>
    <xsl:param name="fieldList"/>

    <xsl:variable name="fieldName">
      <xsl:value-of select="PS.XSLTsearch:getFirstElement($fieldList, ',')"/>
    </xsl:variable>
    <xsl:variable name="remainingFields">
      <xsl:value-of select="PS.XSLTsearch:removeFirstElement($fieldList, ',')"/>
    </xsl:variable>

    <xsl:choose>
      <!-- actually print out field, if it exists and has content -->
      <xsl:when test="count($item/*[not(@isDoc) and name()=string($fieldName)]) = 1 and string($item/*[not(@isDoc) and name()=string($fieldName)]) != ''">
        <xsl:value-of select="string($item/*[not(@isDoc) and name()=string($fieldName)])"/>
      </xsl:when>

      <xsl:when test="$remainingFields != ''">
        <!-- if this element does not exist, go on to the next one -->
        <xsl:call-template name="displayFieldText">
          <xsl:with-param name="item" select="$item"/>
          <xsl:with-param name="fieldList" select="$remainingFields"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <!-- ============================================================= -->


  <xsl:template name="booleanAndMatchedNodes">
    <xsl:param name="yetPossibleNodes"/>
    <xsl:param name="searchTermList"/>

    <xsl:variable name="searchTerm">
      <xsl:value-of select="PS.XSLTsearch:unescapeString(PS.XSLTsearch:getFirstElement($searchTermList, ' '))"/>
    </xsl:variable>
    <xsl:variable name="remainingSearchTermList">
      <xsl:value-of select="PS.XSLTsearch:removeFirstElement($searchTermList, ' ')"/>
    </xsl:variable>

    <xsl:variable name="searchFieldsAttribsOnly">
      <xsl:variable name="sf" select="umbraco.library:Split($searchFields, ',')" />
      <xsl:for-each select="$sf//value">
        <xsl:if test="substring(., 1, 1) = '@'">
          <xsl:text>,</xsl:text>
          <xsl:value-of select="substring-after(., '@') "/>
          <xsl:text>,</xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="attribNodes" select="$yetPossibleNodes[@isDoc 
                                                  and attribute::*[
                                                          contains($searchFieldsAttribsOnly,concat(',', name(), ','))
                                                          and contains(PS.XSLTsearch:uppercase(PS.XSLTsearch:unescapeString(umbraco.library:StripHtml(string(.)))), $searchTerm)
                                                          ]
                                                  ]" />

    <xsl:variable name="propertyNodes" select="$yetPossibleNodes/*[count(@isDoc) = 0 
                                                  and contains($searchFields,concat(',', name(), ','))
                                                  and contains(PS.XSLTsearch:uppercase(PS.XSLTsearch:unescapeString(umbraco.library:StripHtml(string(.)))), $searchTerm) 
                                                  ]/.." />

    <xsl:variable name="evenYetPossibleNodes" select="$attribNodes | $propertyNodes" />

    <xsl:choose>
      <xsl:when test="string-length($remainingSearchTermList) &gt; 1">
        <!-- continue to search the rest of the terms -->
        <xsl:call-template name="booleanAndMatchedNodes">
          <xsl:with-param name="yetPossibleNodes" select="$evenYetPossibleNodes"/>
          <xsl:with-param name="searchTermList" select="$remainingSearchTermList"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <!-- finished searching: return a list of the attribute @id's of the currently possible nodes as the final set of matched nodes -->
        <xsl:variable name="nodeIDList">
          <xsl:text>;</xsl:text>
          <xsl:for-each select="$evenYetPossibleNodes">
            <!-- @id for this node -->
            <xsl:choose>
              <xsl:when test="@isDoc">
                <xsl:value-of select="@id"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="../@id"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>;</xsl:text>
          </xsl:for-each>
        </xsl:variable>

        <!-- return the actual list of id's -->
        <xsl:value-of select="$nodeIDList"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- ============================================================= -->

</xsl:stylesheet>
