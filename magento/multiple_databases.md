# How to have multiple Databases

I inherit a system which has 2 databases, the Magento default and another one which has is used by another system.

I needed to perform a query on the second database but inside a Magento module, this is what I did:

## New DB Configuration

Added the configuration into the `etc/local.xml` file:

```xml
<config>
    <global>

        <!-- ... -->

        <resources>
            <db>
                <table_prefix><![CDATA[]]></table_prefix>
            </db>
            <default_setup>
                <connection>
                    <host><![CDATA[xxxxx]]></host>
                    <username><![CDATA[xxx]]></username>
                    <password><![CDATA[xxx]]></password>
                    <dbname><![CDATA[xxx]]></dbname>
                    <initStatements><![CDATA[SET NAMES utf8]]></initStatements>
                    <model><![CDATA[mysql4]]></model>
                    <type><![CDATA[pdo_mysql]]></type>
                    <pdoType><![CDATA[]]></pdoType>
                    <active>1</active>
                </connection>
            </default_setup>

            <!-- New Database to Use -->

            <new_database_xyz>
                <connection>
                    <host><![CDATA[yyyy]]></host>
                    <username><![CDATA[yyyy]]></username>
                    <password><![CDATA[yyy]]></password>
                    <dbname><![CDATA[yyyy]]></dbname>
                    <initStatements><![CDATA[SET NAMES utf8]]></initStatements>
                    <model><![CDATA[mysql4]]></model>
                    <type><![CDATA[pdo_mysql]]></type>
                    <pdoType><![CDATA[]]></pdoType>
                    <active>1</active>
                </connection>
            </new_database_xyz>
        </resources>

        <!-- ... -->

    </global>
</config>
```


## Module Config

The module name: 





## Reference

http://fishpig.co.uk/magento/tutorials/create-external-database-connection/
