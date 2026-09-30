function [versions, manifest] = getDBCVersions()
    % getDBCVersions Returns a string array of Databricks Connect Versions
    % Order should not be assumed.
    % Data is returned from https://pypi.org/pypi/databricks-connect/json

    %  Copyright 2023-2026 MathWorks, Inc.

    [pypiVersions, pypiManifest] = getPyPIVersions();
    [mvnVersions, mvnManifest] = getMvnVersions();

    [versions, manifest] = mergeVersions(pypiVersions, pypiManifest, mvnVersions, mvnManifest);
end


function [versions, manifest] = getPyPIVersions()
    webOpts = weboptions('Timeout', 30);
    artifact = "databricks-connect";
    pypiUrl = sprintf('https://pypi.org/pypi/%s/json',artifact);
    try
        manifest = webread(pypiUrl, webOpts);
    catch ME
        fprintf("Request for: %s PyPI versions failed, retrying: %s\n  Identifier: %s\n", artifact, pypiUrl, ME.identifier);
        manifest = webread(pypiUrl, webOpts);
    end
    versionsDecoded = string(fieldnames(manifest.releases));

    versions = strip(versionsDecoded);
    versions = strip(versions, 'left', 'x');
    versions = strrep(versions, '_', '.');
end


function [versions, manifest] = getMvnVersions()
    % TODO add pagination support
    % See: https://central.sonatype.org/search/rest-api-guide/#answer
    webOpts = weboptions('Timeout', 30);
    group = "com.databricks";
    artifact = "databricks-connect";
    mvnUrl = "https://central.sonatype.com/solrsearch/select?q=g:" + group + "+AND+a:" + artifact + "&core=gav&rows=20&wt=json";
    try
        data = webread(mvnUrl, webOpts);
    catch ME
        fprintf("Request for: %s Maven versions failed, retrying: %s\n  Identifier: %s\n", artifact, mvnUrl, ME.identifier);
        data = webread(mvnUrl, webOpts);
    end
    if ~isfield(data,'response')
        error("databricks:getDBCVersions:getMvnVersions", "Databricks Connect Maven version query did not return a response value");
    else
        if ~isfield(data.response, 'numFound')
            error("databricks:getDBCVersions:getMvnVersions", "Databricks Connect Maven version query did not return a response.numFound value");
        end
        if ~isfield(data.response, 'docs')
            error("databricks:getDBCVersions:getMvnVersions", "Databricks Connect Maven version query did not return a response.docs value");
        end
    end

    groupFields = split(group, '.');
    downloadBaseUrl = "https://search.maven.org/remotecontent?filepath=";
    
    versions = strings(data.response.numFound, 1);
    downloadJarUrls = strings(data.response.numFound, 1);
    downloadMd5Urls = strings(data.response.numFound, 1);

    for n = 1:data.response.numFound
        versions(n) =  data.response.docs(n).v;
        downloadUrl = downloadBaseUrl;
        for m = 1:numel(groupFields)
            downloadUrl = downloadUrl + groupFields(m) + "/";
        end
        downloadUrl = downloadUrl + artifact + "/" + versions(n) + "/" + artifact + "-" + versions(n);
        downloadJarUrls(n) = downloadUrl + ".jar";
        downloadMd5Urls(n) =  downloadJarUrls(n) + ".md5";
    end
   
    md5Values = getMd5s(downloadMd5Urls);

    manifest = struct;
    for n = 1:numel(versions)
        manifest(n).version = versions(n);
        manifest(n).url = downloadJarUrls(n);
        manifest(n).md5 = md5Values(n);
    end
end


function md5Values = getMd5s(md5Urls)
    arguments
        md5Urls (:,1) string
    end

    len = numel(md5Urls);
    md5Values = strings(len, 1);
    for n = 1:len
        try
            md5Values(n) = string(webread(md5Urls(n)));
        catch
            md5Values(n) = "";
        end
    end
end


function [versions, manifest] = mergeVersions(pypiVersions, pypiManifest, mvnVersions, mvnManifest)
    manifest = mvnManifest;
    versions = mvnVersions;
   
    pypiFields = fieldnames(pypiManifest.releases);
    if numel(pypiVersions) ~= numel(pypiFields)
        error("getDBCVersions:mergeVersions", "Mismatch in number of PyPI versions and manifest entries")
    end

    for n = 1:numel(pypiFields)
        if ~databricks.internal.databricksConnect.isDatabricksConnectv2Version(pypiVersions(n))
            relName = pypiFields{n};
            if ~isempty(pypiManifest.releases.(relName))
                count = numel(versions);
                idx = count + 1;
                versions(idx) = pypiVersions(n);
                manifest(idx).version = pypiVersions(n);
                manifest(idx).md5 = pypiManifest.releases.(relName).digests.md5;
                manifest(idx).url = pypiManifest.releases.(relName).url;
            end
        end
    end
end
