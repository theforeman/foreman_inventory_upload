import React, { Fragment } from 'react';
import { ListView, Icon } from 'patternfly-react';
import PropTypes from 'prop-types';
import { translate as __ } from 'foremanReact/common/I18n';

const labelMapper = {
  1: 'Low',
  2: 'Moderate',
  3: 'Important',
  4: 'Critical',
};

const ListItem = ({ title, totalRisk, resultsUrl, solutionUrl }) => {
  const heading = (
    <p className="ellipsis list-item-heading" title={title}>
      {title}
    </p>
  );

  const riskLabel = labelMapper[totalRisk];
  const additionalInfo = [
    <span key={`risk-info-${title}`} className={`risk-label ${riskLabel}`}>
      <p>{riskLabel}</p>
    </span>,
  ];

  const knowledgebaseLink = solutionUrl && (
    <p>
      <a href={solutionUrl} target="_blank" rel="noopener noreferrer">
        {__('Knowledgebase article')} <Icon name="external-link" />
      </a>
    </p>
  );

  const insightsCloudLink = resultsUrl && (
    <p>
      <a href={resultsUrl} target="_blank" rel="noopener noreferrer">
        {__('Read more about it in RH cloud insights')}{' '}
        <Icon name="external-link" />
      </a>
    </p>
  );

  return (
    <ListView.Item
      heading={heading}
      additionalInfo={additionalInfo}
      hideCloseIcon
    >
      <Fragment>
        <p>{title}</p>
        {knowledgebaseLink}
        {insightsCloudLink}
      </Fragment>
    </ListView.Item>
  );
};

ListItem.propTypes = {
  title: PropTypes.string.isRequired,
  totalRisk: PropTypes.number.isRequired,
  resultsUrl: PropTypes.string,
  solutionUrl: PropTypes.string,
};

ListItem.defaultProps = {
  resultsUrl: '',
  solutionUrl: '',
};

export default ListItem;
