000100110720      * ------------------------------------------------------------------------------
000200110720      *  Copyright 2009 Ronnie Dlomo
000300110720      *
000400110720      *  Licensed under the Apache License, Version 2.0 (the "License");
000500110720      *  you may not use this file except in compliance with the License.
000600110720      *  You may obtain a copy of the License at
000700110720      *
000800110720      *      http://www.apache.org/licenses/LICENSE-2.0
000900110720      *
001000110720      *  Unless required by applicable law or agreed to in writing, software
001100110720      *  distributed under the License is distributed on an "AS IS" BASIS,
001200110720      *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
001300110720      *  See the License for the specific language governing permissions and
001400110720      *  limitations under the License.
001500110720      * ------------------------------------------------------------------------------
001600110718     H BndDir('WEBTOOLS')
001700110718     H NoMain
001800070703
001900110720      /define SERVER_RPGLET
002000110720
002100110718     D gOutputBuffer   s               *
002200110718     D gBufferCursor   s               *
002300110718     D gConfig         s               *
002400110720
002500110720      /COPY WEBRPG_H
002600110720
002700110720     DRPGLET_getOutPutBuffer...
002800110720     D                 PR              *
002900110720
003000110720     DRPGLET_getOutPutStream...
003100110720     D                 PR              *
003200110720
003300110718      /include /home/ronnie/properties/properties_h.rpgle
003400110718      /include /home/ronnie/arraylist/arraylist_h.rpgle
003500110718      /include /home/ronnie/includes/libc_h.rpgle
003600110720      /include '/home/ronnie/libtree/libtree_h.rpgle'
003700110718
003800110718     d/copy SYSPSDS
003900110718
004000110720      * \brief RPGLET_printString
004100110720      *
004200110720      * Outputs the contents of a string to a the output stream
004300110720      *
004400110720      * \param test er to properties object
004500110720      */
004600110720     PRPGLET_printString...
004700110720     P                 B                   export
004800110720     DRPGLET_printString...
004900110720     D                 PI
005000110718     D value                      32000a   value
005100110718
005200110718     D size            s             10I 0
005300110718
005400110718      /Free
005500110719
005600110718               size = %len(%Trim(value));
005700110719               memcpy( gBufferCursor: %addr(value) : size );
005800110718               gBufferCursor += size;
005900110718      /End-Free
006000110718     P                 E
006100110718
006200110720     /**
006300110720      * \brief RPGLET_setContentType  sets the output content type
006400110720      *
006500110720      *
006600110720      * \params  String context Type eg text/xml
006700110720      */
006800110720
006900110720     PRPGLET_setContentType...
007000110720     P                 B                   Export
007100110720     DRPGLET_setContentType...
007200110720     D                 PI
007300110718     D @value                     32000a   const varying
007400110718      /Free
007500110718           properties_put(gConfig: 'contentType' : %Trim(@value) );
007600110718      /End-Free
007700110718     P                 E
007800110720     /**
007900110720      * \brief RPGLET_setOutputStream sets the config attributes
008000110720      *
008100110720      *
008200110720      * \params  Pointer to config attributes
008300110720      */
008400110720
008500110718
008600110720     PRPGLET_setOutputStream...
008700110720     P                 B                   Export
008800110720     DRPGLET_setOutputStream...
008900110720     D                 PI
009000110718     D @buffer                         *
009100110718
009200110718      /Free
009300110718            gOutputBuffer = @buffer;
009400110718            gBufferCursor = @buffer;
009500110718      /End-Free
009600110718     P                 E
009700110718
009800110720     /**
009900110720      * \brief RPGLET_setConfig
010000110720      *
010100110720      *
010200110720      * \params  Pointer to config attributes
010300110720      */
010400110720
010500110720     PRPGLET_setConfig...
010600110720     P                 B                   Export
010700110720     DRPGLET_setConfig...
010800110720     D                 PI
010900110718     D @config                         *
011000110718
011100110718      /Free
011200110718            gConfig = @config;
011300110718      /End-Free
011400110718     P                 E
011500110718
011600110720     /**
011700110720      * \brief getOutputBuffer
011800110720      *
011900110720      * returns the current write position of the output buffer
012000110720      *
012100110720      * \returns Pointer to output buffer
012200110720      */
012300110720
012400110720     PRPGLET_getOutPutBuffer...
012500110720     P                 B
012600110720     DRPGLET_getOutPutBuffer...
012700110720     D                 PI              *
012800110718
012900110718      /Free
013000110718            return gBufferCursor;
013100110718      /End-Free
013200110718     P                 E
013300110720     /**
013400110720      * \brief getOutputStream
013500110720      *
013600110720      * returns the contents of the buffer
013700110720      *
013800110720      * \param Pointer to a null terminated string containing
013900110720      *         serialized properties
014000110720      * \returns properties object
014100110720      */
014200110718
014300110720     PRPGLET_getOutPutStream...
014400110720     P                 B
014500110720     DRPGLET_getOutPutStream...
014600110720     D                 PI              *
014700110718
014800110718      /Free
014900110718            return gOutputBuffer;
015000110718      /End-Free
015100110718     P                 E
015200110718
015300110720     /**
015400110720      * \brief toString  properties
015500110720      *
015600110720      * loads properties from a null terminated string).
015700110720      *
015800110720      * \param Pointer to a null terminated string containing
015900110720      *         serialized properties
016000110720      */
016100110720     PRPGLET_propertiesFromString...
016200110718     P                 B                     Export
016300110720     DRPGLET_propertiesFromString...
016400110718     D                 PI              *
016500110718     D buffer                          *     const
016600110718
016700110718     dproperties       s               *
016800110718     dline             s               *
016900110718     dindex            s               *
017000110718     ditem             s               *
017100110718     dvalue            s               *
017200110718
017300110718     d EOL             C                    X'00'
017400110718     d CR              C                    X'0D'
017500110718
017600110718     d @x              s             10I 0
017700110718     d @y              s             10I 0
017800110718
017900110718     d@pos             s               *                                        cursor
018000110718     d wbuf            ds                        based(@pos)
018100110718     d  buf                           1a         OverLay(wbuf)                  reflector
018200110718
018300110718      /free
018400110718         properties = properties_create();
018500110718         @pos  = buffer;
018600110718
018700110718         DoW ( buf <> EOL );
018800110718             line = %alloc(5000);
018900110718             index = line;
019000110718             @y = 0;
019100110718             doW  ( (buf <> CR) and ( buf <> EOL ) );
019200110718                   if buf <> '"';
019300110718                      %str(index:2) = buf;
019400110718                      index+=1;
019500110718                      @y += 1;
019600110718                   endif;
019700110718                    // increment the pointer to buffer
019800110718                   @pos+=1;
019900110718             EndDo;
020000110718             // move buffer to next character after CR
020100110718             if (buf <> EOL );
020200110718                 @pos+=1;
020300110718             EndIf;
020400110718             // splits the property into key, value
020500110718             @x = %scan('=' : %str(line) );
020600110718             // when separator token found and a non blank line found ;
020700110718             if ( @x > 1 ) and ( @y > 0 ) ;
020800110718                 item = %alloc(5000);
020900110718                 value = %alloc(5000);
021000110718                 %str(item:@x) = %subst( %Str(line)  : 1 : @x-1);
021100110718                 if ( @x <> @y );
021200110718                   %str(value: (@y-@x)+1) = %subst(%str(line) : @x+1);
021300110718                 else;
021400110718                   %str(value: 2 ) = ' ';
021500110718                 endif;
021600110718                 properties_put(properties : %str(item): %str(value) );
021700110718                 dealloc item;
021800110718                 dealloc value;
021900110718             Endif;
022000110718             dealloc line;
022100110718         EndDo;
022200110718         return properties;
022300110718       /End-Free
022400110718     P                 E
022500110720     /**
022600110720      * \brief toString  properties
022700110720      *
022800110720      * Outputs all properties as a null terminated string).
022900110720      *
023000110720      * \param Pointer to properties object
023100110720      */
023200110720     P RPGLET_propertiesToString...
023300110720     P                 B                   export
023400110720     D                 PI              *
023500110720     D  properties                     *   const
023600110720      *
023700110720     D len             S             10I 0
023800110720     D node            DS                  likeds(tree_node_string_t) based(ptr)
023900110720     D retStr          s               *
024000110720     D index           s               *
024100110720      /free
024200110720       ptr = tree_rb_string_first(properties);
024300110720       retStr=%alloc(1000000);
024400110720       index = retStr;
024500110720
024600110720       dow (ptr <> *null);
024700110720          // key
024800110720          memcpy(index : node.key : node.keylength);
024900110720          index += node.keylength;
025000110720          // separator
025100110720
025200110720          %str(index:2) = '=';
025300110720          index = index + 1;
025400110720
025500110720          // value
025600110720          memcpy(index : node.value : node.length);
025700110720          index = index + node.length;
025800110720
025900110720          // end of line
026000110720          %str(index:3) = x'0d25';
026100110720          index = index + 2;
026200110720
026300110720          ptr = tree_rb_string_next(ptr);
026400110720       enddo;
026500110720
026600110720       return retStr;
026700110720      /end-free
026800110720     P                 E
