import BaseConfig from './next.config.base.mjs';
 


/** @type {import('next').NextConfig} */
const nextConfig = {
    ...BaseConfig  , 

    output: 'standalone',

};

export default nextConfig;
