/* eslint-disable translation/no-strings-without-translations */
import React from 'react';
import { Spinner } from '@patternfly/react-core';
import { CheckIcon, TimesIcon } from '@patternfly/react-icons';

const STATUS_ICONS = {
  success: <CheckIcon />,
  failure: <TimesIcon />,
  running: <Spinner size="sm" />,
  unknown: <span>--</span>,
};

export const getStatusIconByRegex = status => {
  if (!status || status === 'unknown') {
    return STATUS_ICONS.unknown;
  }

  const statusCopy = status.toLowerCase();
  if (statusCopy.indexOf('exit 0') !== -1) {
    return STATUS_ICONS.success;
  }

  if (
    statusCopy.indexOf('running') !== -1 ||
    statusCopy.indexOf('restarting') !== -1
  ) {
    return STATUS_ICONS.running;
  }

  return STATUS_ICONS.failure;
};
