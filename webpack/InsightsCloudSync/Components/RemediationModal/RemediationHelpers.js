/* eslint-disable camelcase */
import React from 'react';
import Resolutions from './Resolutions';

export const modifyRows = (remediations, setResolutions, setHostsIds) => {
  if (remediations.length === 0) return [];

  const resolutionToSubmit = [];
  const hostsIdsToSubmit = new Set();
  const modifiedRemediations = remediations
    .asMutable()
    .map(({ id, host_id, hostname, title, resolutions, reboot }) => {
      hostsIdsToSubmit.add(host_id);
      resolutionToSubmit.push({
        host_id,
        hit_id: id,
        resolution_id:
          resolutions[0].id /** defaults to the first resolution if many */,
      });
      return {
        cells: [
          hostname,
          title,
          <div>
            <Resolutions
              hit_id={id}
              resolutions={resolutions}
              setResolutions={setResolutions}
            />
          </div>,
          reboot,
        ],
        id,
      };
    });

  setResolutions(resolutionToSubmit);
  setHostsIds(Array.from(hostsIdsToSubmit));
  return modifiedRemediations;
};