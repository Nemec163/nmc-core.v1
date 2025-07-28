import React from 'react';
import * as LucideIcons from 'lucide-react';
import { LucideProps } from 'lucide-react';

export interface IconProps extends LucideProps {
  name: keyof typeof LucideIcons;
}

const Icon: React.FC<IconProps> = ({ name, size = 24, color = 'currentColor', ...props }) => {
  const Component = LucideIcons[name] as React.FC<LucideProps>;
  if (Component) {
    return <Component size={size} color={color} {...props} />;
  }

  console.warn(`Icon: icon with name "${name}" not found in lucide-react`);
  const Fallback = LucideIcons.HelpCircle;
  return <Fallback size={size} color={color} {...props} />;
};

export default Icon;
