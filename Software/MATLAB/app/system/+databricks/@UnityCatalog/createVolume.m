function result = createVolume(obj, catalog_name, schema_name, name, volume_type, storage_location, comment)
    % CREATEVOLUME Creates a new volume.
    % Creates either an external volume or a managed volume.
    % An external volume will be created in the specified external location,
    % while a managed volume will be located in the default location which
    % is specified by the parent schema, or the parent catalog, or the Metastore.
    %
    % For the volume creation to succeed, the user must satisfy following conditions:
    %  * The caller must be a metastore admin, or be the owner of the parent
    %    catalog and schema, or have the USE_CATALOG privilege on the parent
    %    catalog and the USE_SCHEMA privilege on the parent schema.
    %
    %  * The caller must have CREATE VOLUME privilege on the parent schema.
    %
    % For an external volume, following conditions also need to satisfy:
    %  * The caller must have CREATE EXTERNAL VOLUME privilege on the external location.
    %
    %  * There are no other tables, nor volumes existing in the specified storage location.
    %
    %  * The specified storage location is not under the location of other tables,
    %    nor volumes, or catalogs or schemas.
    %
    % Example:
    %
    %   result = uc.createShare(shareinfo);
    %
    % Required Inputs:
    %   catalog_name
    %       Description: 
    %           The identifier of the catalog
    %       Type:
    %           string
    %   schema_name
    %       Description:
    %           The identifier of the schema
    %       Type:
    %           string
    %   name
    %       Description:
    %           Volume name
    %       Type:
    %           string
    %   volume_type
    %       Description:
    %           Type of volume e.g. EXTERNAL or MANAGED
    %       Type:
    %           databricks.datastructures.unitycatalog.VolumeType
    %   storage_location
    %       Description:
    %           Underlying volume storage location
    %           If creating a volume of type MANAGED then the
    %           storage_location value is not used and "" can be
    %           specified for this argument
    %       Type:
    %           string
    %   comment
    %       Description:
    %           Comment field, user-supplied free-form text
    %       Type:
    %           string
    %
    % Outputs:
    %   result  
    %       Description:
    %           settings/configuration of the created share
    %       Type:
    %           databricks.datastructures.unitycatalog.VolumeInfo
    %
    % See Also: databricks.datastructures.unitycatalog.VolumeInfo,
    %
    %           https://docs.databricks.com/api/workspace/volumes/create
    
    % Copyright 2024-2026 The MathWorks, Inc.

    arguments
        obj databricks.UnityCatalog
        catalog_name string {mustBeTextScalar}
        schema_name string {mustBeTextScalar}
        name string {mustBeTextScalar}
        volume_type (1,1) databricks.datastructures.unitycatalog.VolumeType
        storage_location string {mustBeTextScalar}
        comment string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'volumes');

    % Start a POST request
    request = obj.getRequestMessage('POST');

    % Set the body - all simple types so can use jsonencode
    s = struct;
    s.catalog_name = catalog_name;
    s.schema_name = schema_name;
    s.name = name;
    s.volume_type = volume_type;
    if s.volume_type ~= databricks.datastructures.unitycatalog.VolumeType.MANAGED
        s.storage_location = storage_location;
    end
    s.comment = comment;

    request.Body(1).Payload = jsonencode(s);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.VolumeInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end