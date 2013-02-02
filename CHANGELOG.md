## v0.6.0:
* Change  : Change storage_aggregation attribute to also use priorities like storage_schema attribute

## v0.5.1:
* BugFix  : Fix how priorities are treated in storage_schema attribute

## v0.5.0:

* Change  : Prefer new notification syntax.
* Enhance : Support udp listener in carbon. Submitted By Kurt Yoder.
* Change  : Remove the gdash integration in apache site. Users should move to using a separate vhost for gdash where
            possible.

## v0.3.6:

* Fix     : Priority is no longer used in storage-schema so instead order the storage-schemas using the
            priority. Submitted By Viral Shah.

## v0.3.3:

* Enhance : Support collection of storage schema configuration from other nodes through search.
* Enhance : Update to support configuration of storage schemas through attributes.

## v0.3.2:

* Enhance : Add preliminary in support for RPM based systems.
* Enhance : Add support for configuring the ports on which the line_receiver, pickle_receiver and cache_query
            services listen to. Rework the configuration of the interfaces - see the default attributes for details.

## v0.3.1:

* Initial release tracked.
